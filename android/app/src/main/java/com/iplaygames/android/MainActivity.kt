package com.iplaygames.android

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

private val Purple = Color(0xFF6D28D9)
private val Deep = Color(0xFF160A3B)
private val Games = listOf(
    Game("Trivia Sprint", "Brain", "Answer quick-fire questions."),
    Game("Rock Paper Scissors", "Quick", "Challenge a friend."),
    Game("Tic-Tac-Toe", "Strategy", "Take turns placing X and O."),
    Game("Word Scramble", "Brain", "Unscramble the hidden word."),
    Game("Riddle Duel", "Brain", "Solve a riddle before your opponent."),
    Game("Number Guess", "Quick", "Guess the secret number.")
)
private data class Game(val title: String, val category: String, val description: String)

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent { iPlayApp() }
    }
}

@Composable
private fun iPlayApp() {
    var selected by remember { mutableStateOf<Game?>(null) }
    var category by remember { mutableStateOf("All") }
    val categories = listOf("All", "Brain", "Quick", "Strategy")
    val visible = Games.filter { category == "All" || it.category == category }

    MaterialTheme(colorScheme = darkColorScheme(
        primary = Color(0xFF9B7BFF),
        background = Deep,
        surface = Color(0xFF24144F)
    )) {
        Box(
            Modifier.fillMaxSize().background(
                Brush.verticalGradient(listOf(Color(0xFF3B0A91), Deep, Color(0xFF08051B)))
            )
        ) {
            Column(Modifier.fillMaxSize().statusBarsPadding().padding(horizontal = 18.dp)) {
                Spacer(Modifier.height(18.dp))
                Text("iPlay", color = Color.White, fontSize = 36.sp, fontWeight = FontWeight.Black)
                Text("Your games. Your people.", color = Color(0xFFD7C8FF), fontSize = 15.sp)
                Spacer(Modifier.height(22.dp))

                if (selected == null) {
                    Text("CHOOSE A GAME", color = Color.White, fontWeight = FontWeight.Bold, letterSpacing = 2.sp)
                    Spacer(Modifier.height(12.dp))
                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        categories.forEach { item ->
                            FilterChip(
                                selected = category == item,
                                onClick = { category = item },
                                label = { Text(item) }
                            )
                        }
                    }
                    Spacer(Modifier.height(14.dp))
                    LazyVerticalGrid(
                        columns = GridCells.Fixed(2),
                        verticalArrangement = Arrangement.spacedBy(12.dp),
                        horizontalArrangement = Arrangement.spacedBy(12.dp),
                        contentPadding = PaddingValues(bottom = 24.dp)
                    ) {
                        items(visible) { game ->
                            Card(
                                modifier = Modifier.fillMaxWidth().height(145.dp)
                                    .clickable { selected = game },
                                shape = RoundedCornerShape(20.dp),
                                colors = CardDefaults.cardColors(containerColor = Color(0xCC29165C))
                            ) {
                                Column(Modifier.fillMaxSize().padding(14.dp), verticalArrangement = Arrangement.SpaceBetween) {
                                    Text(game.category.uppercase(), color = Color(0xFFBDA5FF), fontSize = 10.sp, fontWeight = FontWeight.Bold)
                                    Text(game.title, color = Color.White, fontWeight = FontWeight.Bold, fontSize = 17.sp)
                                    Text("Play  →", color = Color(0xFF8FEAFF), fontSize = 13.sp)
                                }
                            }
                        }
                    }
                } else {
                    TextButton(onClick = { selected = null }) { Text("← All games") }
                    Spacer(Modifier.height(20.dp))
                    Text(selected!!.title, color = Color.White, fontSize = 28.sp, fontWeight = FontWeight.Bold)
                    Spacer(Modifier.height(8.dp))
                    Text(selected!!.description, color = Color(0xFFD7C8FF), fontSize = 16.sp)
                    Spacer(Modifier.height(22.dp))
                    Card(colors = CardDefaults.cardColors(containerColor = Color(0xCC29165C)), shape = RoundedCornerShape(18.dp)) {
                        Column(Modifier.fillMaxWidth().padding(18.dp)) {
                            Text("Game preview", color = Color.White, fontWeight = FontWeight.Bold)
                            Spacer(Modifier.height(8.dp))
                            Text("This Android game screen is the starting point. Online invitations and shared matches will be connected in the next development milestone.", color = Color(0xFFD7C8FF))
                        }
                    }
                }
            }
        }
    }
}
