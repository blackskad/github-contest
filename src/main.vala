/* main.vala
 *
 * Copyright (C) 2009  Thomas Meire
 *
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author:
 * 	Thomas Meire <blackskad@gmail.com>
 */

using GLib;

public class contest.Main : Object {

	private Gee.Map<int, Gee.List<int>> followers;
	private Gee.List<int> testcases;

	private Gee.Map<int, Gee.Map<int,int>> correlation;
	
	public Main () {
	}

	construct {
		followers = new Gee.HashMap<int, Gee.List<int>>();
		loadFollowers();

		testcases = new Gee.ArrayList<int>();
		loadTesters();

		calculateUserCorrelation();
	}

	/* load the followers from file */
	private void loadFollowers () {
		File file = File.new_for_path ("download/data.txt");
		try {
			// Open file for reading and wrap returned FileInputStream into a
			// DataInputStream, so we can read line by line
			var in_stream = new DataInputStream (file.read (null));
			string line; string[] x;
			// Read lines until end of file (null) is reached
			while ((line = in_stream.read_line (null, null)) != null) {
				x = line.split(":");
				if (x.length != 2) {
					continue;
				}
				int y = x[0].to_int();
				if (followers[y] == null) {
					followers[y] = new Gee.ArrayList<int>();
				}
				followers[y].add(x[1].to_int());
			}
		} catch (Error e) {
			error ("%s", e.message);
		}
	}

	private Gee.List<int> testers () {
		File file = File.new_for_path ("download/test.txt");
		Gee.List<int> testers = new Gee.ArrayList<int>();
		try {
			var in_stream = new DataInputStream (file.read (null));
			string line;
			// Read lines until end of file (null) is reached
			while ((line = in_stream.read_line (null, null)) != null) {
				testers.add(line.to_int());
			}
		} catch (Error e) {
			error ("%s", e.message);
		}
		return testers;
	}

	private Gee.List<int> topten (Gee.Map<int, int> repos) {
		Gee.List<int> result = new Gee.ArrayList<int>();
		foreach (int repo in repos.get_keys()) {
			int i = 0;
			while (i < result.size && i < 10 && repos[repo] < repos[result[i]]) {
				i++;
			}
			if (i == result.size && i < 10) {
				result.add(repo);
			} else if (i < 10) {
				result.insert(i, repo);
			}
		}
		return result;//.slice(0,10);
	}

	public void run () {
		File file = File.new_for_path ("results.txt");
		var stream = file.create (FileCreateFlags.NONE, null);
		var output = new DataOutputStream (stream);

		Gee.List<int> tests = testers ();
		int counter = 1;
		foreach (int test in tests) {
			debug("#%i - Finding recommendations for %i", counter, test);
			Gee.Map<int, int> repos = new Gee.HashMap<int, int>();

			foreach (int uid in followers.get_keys()) {
				int sim = 0;
				foreach (int repo in followers[uid]) {
					if (repo in followers[test]) {
						sim++;
					}
				}
				foreach (int repo in followers[uid]) {
					repos[repo] += sim;
				}
			}
			// find the top ten out of repos
			Gee.List<int> p = topten(repos);
			//debug("%i:%i,%i,%i,%i,%i,%i,%i,%i,%i,%i",
			//	test, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]);
			output.put_string("%i:%i,%i,%i,%i,%i,%i,%i,%i,%i,%i\n".printf(
				test, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9]), null);
			counter++;
		}
	}

	static int main (string[] args) {
		var main = new Main ();
		main.run ();
		return 0;
	}
}
