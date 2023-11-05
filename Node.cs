using Godot;
using System;

public class Node : Godot.Node
{
private void run_cmd(string cmd, string args)
{
ProcessStartInfo start = new ProcessStartInfo();
start.FileName = cmd;//cmd is full path to python.exe
start.Arguments = args;//args is path to .py file and any cmd line args
start.UseShellExecute = false;
start.RedirectStandardOutput = true;
using(Process process = Process.Start(start))
{
using(StreamReader reader = process.StandardOutput)
{
string result = reader.ReadToEnd();
Console.Write(result);
}
}
}

	public void _Ready(){
		run_cmd()
	}
}
