using Godot;
using System;
using 

public partial class GameLoop : Node2D 

{
	Label compliment;
	public override void _Ready()
	{
		compliment = (Label)GetNode("./Control/Margin/CanvasLayer/Compliment");
		compliment.Text = "Press the button to receive a compliment.";
	}
	
	private void _on_please_button_down()
	{
		compliment.Text = "Random!";
	}
}
