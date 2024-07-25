/*
  IMPORTANT NOTE!!: AS AN ASSUMPTION INPUT NAMES FOR SONGS MUST
  BE GIVEN AS SINGLE TOKEN WITHOUT SPACES AS I USED scanf("%s")
  FUNCTION FOR READING SONG NAMES AS INPUTS 
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct dynamic_array {
    int capacity;
    int size;
    void** elements;
} dynamic_array;

// function prototypes
void init_array(dynamic_array*);
void put_element(dynamic_array*,void*);
void remove_element(dynamic_array*,int);
void* get_element(dynamic_array*,int);
void list_songs(dynamic_array*);

void init_array(dynamic_array* array) {
   // assigning the capacity of array 2
   array->capacity = 2;
   array->size = 0;
   array->elements = malloc(sizeof(void*)*2);

   // assigning allocated void pointers to 
   // elements array entries 
   for (int i = 0; i < array->capacity; i++)
   {
     
      void* element = malloc(sizeof(void));
      element = NULL;
      array->elements[i] = element;
        
   }
}

void put_element(dynamic_array* array, void* element) {
     
     // checking whether the size reached to capacity
     if ((array->size) == ((array->capacity)))
     {    
           // increasing the capacity two times the previous
         int prev_size = array->size;
         array->capacity *= 2;
         
         void** new_elements = malloc(array->capacity * sizeof(void*));
         // copying the elements array into newly allocated elements array 
         void** prev_elements = array->elements;
         array->elements = new_elements;
         
         int unfilled_entries = 0;
         for (int i = 0; i < prev_size; i++)
         {
           void* entry  = malloc(sizeof(void)); 
           entry = NULL;
           array->elements[i] = entry;
           (array->elements)[i] = prev_elements[i];
           unfilled_entries++;
         }
  
         // Assigning entries that haven't pointed to
         // any valid songs yet 
         for (int i = unfilled_entries; i < array->capacity; i++)
         {

            void* null_entry = malloc(sizeof(void));
            null_entry = NULL;
            (array->elements)[i] = null_entry;
         }
     }

     //void* song = (void* ) any_song;
     (array->elements)[array->size] = element; 
     array->size = array->size + 1;
     printf("\n");
}

void remove_element(dynamic_array* array,int position) {

     // we check whether the size is less than or equal
     // to capacity/2
     if(array->size < (array->capacity)/2)
     {
         // reducing capacity by factor of 2
         array->capacity /= 2;  
         // dynamically allocating memory 
         //for new elements array
         void** new_elements = malloc(array->capacity*sizeof(void*)); 
         // copy the elements of old array into new elements array
         void** prev_elements = array->elements;
         array->elements = new_elements;
         //array->elements = new_elements;
         int unfilled_entries = 0;

         for (int i = 0; i < array->size; i++)
         { 
            void* entry = malloc(sizeof(void));
            entry = NULL;
            array->elements[i] = entry;
            array->elements[i] = prev_elements[i];
            unfilled_entries++;
         }
         
         // Assigning the entries that haven't
         // pointed to any valid songs yet
         for (int i = unfilled_entries; i < array->capacity; i++)
         {

            void* entry = malloc(sizeof(void));
            entry = NULL;
            array->elements[i] = entry;  
         }  
         
         // deallocating the old elements array
         free(prev_elements);
     }
      
     // After the if statement, capacity is reduced by factor of 2 
     int index = 0; 
     for (int i = 0; i < array->size; i++)
     {
         if(position == i)
         {
            // shifting the array entries
           index++;
         }
  
         array->elements[i] = array->elements[index];
         index++;
       } 

       // decrementing size by one 
       array->size = array->size -1;
} 

void* get_element(dynamic_array* array, int position) {
    
    return (array->elements[position]);
}

typedef struct song {
   char* name;
   float duration;
} song;

// This is a function that I have provided
// to list all the songs in the song list
void list_songs(dynamic_array* array)
{

   printf("\n---LIST OF SONGS---\n\n");
   printf("--Song Names--\n");

   for (int i = 0; i < array->size; i++)
   {
     
     song* an_song = (song* )get_element(array,i);
     printf("%d.%s\n",i+1,an_song->name);
   }

   printf("\n--Song Durations--\n");
   for (int i = 0; i < array->size; i++)
   {
     
     song* an_song = (song* )get_element(array,i);
     printf("%d.%.2f\n",i+1,an_song->duration); 
   }
}

int main() {

// creating an pointer to dynamic_array 
dynamic_array* d_array = (dynamic_array* )malloc(sizeof(dynamic_array));
// calling init_array function to initialize the song list
init_array(d_array);
printf("SONG LIST IS INITIALIZED\n");

int run_application = 1;
while (run_application)
{
    printf("\n--MAIN MENU--\n"); 
    int option;

    printf("1.Add a song to list\n");
    printf("2.Remove song from list\n");
    printf("3.Show the songs in the list\n");
    printf("4.Exit\n");

    printf("\nEnter your choice(1-4): ");
    scanf("%d",&option);
   
    switch (option)
    {
      
      case 1:
           void* element = malloc(sizeof(song)); 
           // Taking the name and duration of the song
           // that user wants to add 
           char* song_name = (char* )malloc(sizeof(char)*30);
           printf("\nEnter the name of the song: ");
           scanf("%s",song_name);
           printf("Enter the duration of the song: ");
           float song_duration;
           scanf("%f",&song_duration);

          song* any_song = (song*)element;
          any_song->name = song_name;
          any_song->duration = song_duration;
          element = (void*) element;
          put_element(d_array,element);
          break; 
      case 2:
           // Taking the name of the song to be delted 
          char* song_name_to_delete = (char* )malloc(sizeof(char)*30);
          printf("\nEnter the name of the song that you want to delete: ");
          scanf("%s",song_name_to_delete); 
          int pos = -1;
          // Searching for a given song
          for (int i = 0; i < d_array->size; i++)
          {
             if(!strcmp(((song*)d_array->elements[i])->name,song_name_to_delete))
             {
                pos = i;
                break;
             }
          } 

          if (pos != -1)
          {    
            void* song_searched = get_element(d_array,pos); 
            free(song_searched);
            remove_element(d_array,pos);   
          }
          
          else
          {

            printf("\nSONG TO BE DELETED WAS NOT FOUND!!\n\n");
          }
          break; 
      case 3:
           list_songs(d_array);
           break;
      case 4:
           run_application = 0;
           printf("\nAPPLICATION HAS ENDED\n\n");
           break;
      default:
           // if invalid option is given
           printf("\nInvalid input please enter a valid input!!\n");                           
    }
}
return 0;
}