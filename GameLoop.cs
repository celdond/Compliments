using Godot;
using System;

public partial class GameLoop : Node2D 

{
	Label compliment;
	GodotObject database;
	Int32 count;
	Random random;
	public override void _Ready()
	{
		random = new Random();
		GDScript DatabaseScript = (GDScript)GD.Load("res://data/database_access.gd");
		database = (GodotObject)DatabaseScript.New();
		count = (Int32)database.Call("get_compliment_count");
		compliment = (Label)GetNode("./Control/Margin/CanvasLayer/Compliment");
		compliment.Text = "Press the button to receive a compliment.";
	}
	
	private void _on_please_button_down()
	{
		int selection = random.Next(0, count);
		compliment.Text = (string)database.Call("get_compliment", selection);
	}
}
