
import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
int NUM_ROWS = 20;
int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public String message = "";
public boolean gameover=false;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    strokeWeight(2);
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons= new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i<NUM_ROWS; i++){
        for(int j = 0; j<NUM_COLS; j++){
            buttons[i][j]= new MSButton(i,j);
        }
    }
    
    
    setBombs();
}
public void setBombs()
{
    for(int k = 0; k < 40; k++) {
        int row = (int)(Math.random()*20);
        int col = (int)(Math.random()*20);
        if(!bombs.contains(buttons[row][col])){
            bombs.add(buttons[row][col]);
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
            if(!buttons[r][c].isMarked() && !buttons[r][c].isClicked()){
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    
    message = "HOT LAVA";
    gameover = true;
    for(int row=0; row<NUM_ROWS; row++){
      for(int col=0; col<NUM_COLS; col++){
        if(bombs.contains(buttons[row][col])){
          buttons[row][col].setLabel("B");
          
          bombs.remove(buttons[row][col]);
        }
      }
    }
       
    for (int i = 0; i <= message.length(); i++)
        buttons[10][i + 6].setLabel(""+message.charAt(i));
}
public void displayWinningMessage()
{
    message = "YOU WIN";
    for(int row=0; row<NUM_ROWS; row++)
      for(int col=0; col<NUM_COLS; col++)
        bombs.remove(buttons[row][col]);
    for (int i = 0; i <= message.length(); i++)
        buttons[10][i + 6].setLabel(""+message.charAt(i));
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
         if(mouseButton == LEFT && gameover == false && isMarked()==false)
                clicked=true;
          if(mouseButton == RIGHT && gameover == false && isClicked()==false){
              marked = !marked;
          } 
        else if(bombs.contains(this) && isMarked()==false){
            displayLosingMessage();
        }
        else if(countBombs(r,c) > 0){
            if(isMarked()==false)
            label = "" + countBombs(r, c);
            else if(isMarked()==true)
            clicked=!clicked;
        }
        else{
            if(isValid(r,c-1) && buttons[r][c-1].isClicked() == false)
                buttons[r][c-1].mousePressed();
            if(isValid(r,c+1) && buttons[r][c+1].isClicked() == false)
                buttons[r][c+1].mousePressed();
            if(isValid(r-1,c) && buttons[r-1][c].isClicked() == false)
                buttons[r-1][c].mousePressed();
            if(isValid(r+1,c) && buttons[r+1][c].isClicked() == false)
                buttons[r+1][c].mousePressed();
            if(isValid(r-1,c-1) && buttons[r-1][c-1].isClicked() == false)
                buttons[r-1][c-1].mousePressed();
            if(isValid(r-1,c+1) && buttons[r-1][c+1].isClicked() == false)
                buttons[r-1][c+1].mousePressed();
            if(isValid(r+1,c-1) && buttons[r+1][c-1].isClicked() == false)
                buttons[r+1][c-1].mousePressed();
            if(isValid(r+1,c+1) && buttons[r+1][c+1].isClicked() == false)
                buttons[r+1][c+1].mousePressed();
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r>=0&&r<NUM_ROWS&&c>=0&&c<NUM_COLS){
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        if (isValid(row+1, col) && bombs.contains(buttons[row+1][col])){numBombs++;}
        if (isValid(row-1, col) && bombs.contains(buttons[row-1][col])){numBombs++;}
        if (isValid(row+1, col+1) && bombs.contains(buttons[row+1][col+1])){numBombs++;}
        if (isValid(row+1, col-1) && bombs.contains(buttons[row+1][col-1])){numBombs++;}
        if (isValid(row, col+1) && bombs.contains(buttons[row][col+1])){numBombs++;}
        if (isValid(row, col-1) && bombs.contains(buttons[row][col-1])){numBombs++;}
        if (isValid(row-1, col+1) && bombs.contains(buttons[row-1][col+1])){numBombs++;}
        if (isValid(row-1, col-1) && bombs.contains(buttons[row-1][col-1])){numBombs++;}
        return numBombs;
    }
}



