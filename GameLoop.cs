using Godot;
using System;

public partial class GameLoop : Node2D 

{
	Label compliment;
	GodotObject database;
	Variant compliments;
	public override void _Ready()
	{
		GDScript DatabaseScript = (GDScript)GD.Load("res://data/database_access.gd");
		database = (GodotObject)DatabaseScript.New();
		compliments = (Variant)database.Call("get_compliments");
		compliment = (Label)GetNode("./Control/Margin/CanvasLayer/Compliment");
		compliment.Text = "Press the button to receive a compliment.";
	}
	
	private void _on_please_button_down()
	{
		compliment.Text = "Random!";
	}
}
