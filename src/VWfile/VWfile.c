/*
Philips VideoWriter 4460 file viewer
Uses flat image file of disk as input data
Select one of files on disk
output to console text of file
attempt translation of VW format to ascii
based VW2MSX.BAS a program by Peter van Overbeek 1992.
more info here https://hblankes.home.xs4all.nl/Museum/txt/videowriter.htm
comments in code refer to line numbers in VW2MSX.BAS program
*/
#include<stdio.h>
#include<string.h>

#define SIZE 1
#define NUMELEM 0x1200

#define LENGTH_SECTOR   0x100
#define SECTORS_TRACK   18
#define BOOT_RESERVE    0x0
#define LENGTH_TRACK    (LENGTH_SECTOR * SECTORS_TRACK)

#define DISK_IMG_FILE "../../disks/VW1.img"

int T[32];
int S[32];

int FT[256];
int FS[256];

int current_track = -1;
int current_offset;
int result;

const unsigned char w[] = {
/*0x22,*/0x90,0x20,0x99,0x20,0x20,0x9A/*,0x22*/
};
const unsigned char v[] = {
/*0x22,*/0x5E,0x60,0x27,0x2A,0x2A,0x2A,0x84,0x2A,0x83,0x85,0xA0,0x2A,0x2A,0x2A,0x89,0x88,0x8A,0x82,0x8B,0x8C,0x8D,0xA1,0x2A,0x94,0x2A,0x93,0x95,0xA2,0x2A,0x81,0x96,0x97,0xA3/*,0x22*/
};
int read_track(int number_track, char * buffer_track)
{

    FILE* fd = NULL;
    int file_offset;

    file_offset = number_track * LENGTH_TRACK;

    current_offset = file_offset;
//    printf("\ncurent_offset=0x%x",current_offset);
    if(current_track == number_track)
    {
        printf("\nreusing track %d",number_track);
        return 0;
    }

//    printf("\nbuffering track #%d",number_track);

    memset(buffer_track,0,sizeof(buffer_track));


    fd = fopen(DISK_IMG_FILE,"r");

    if(NULL == fd)
    {
        printf("\n fopen() Error!!!\n");
        return 1;
    }

//    printf("\nseek to position 0x%X",file_offset);


    if(0 != fseek(fd, file_offset, SEEK_CUR))
    {
        printf("\n fseek() failed\n");
        return 1;
    }

    result=fread(buffer_track,SIZE,LENGTH_TRACK,fd);

        // bug here somewhere, sometimes not all bytes read

//    if(LENGTH_TRACK != result);
    {
//        printf("\n fread() failed %d\n",result);
        return 1;
    }
    printf("\n fread() ok %d\n",result);

    fclose(fd);
    //printf("\n File stream closed through fclose()\n");

    current_track = number_track;
    return 0;
}


int main(void)
{
    FILE* fd = NULL;
    unsigned char c,buff[LENGTH_TRACK];
    char filename[21];
    int d,g,h,i,j,k,n,p,q,m,s,t,y, number_of_files, file_number;
    memset(filename,0,sizeof(filename));
    memset(buff,0,sizeof(buff));

    t=0;
    read_track(t, buff);

    number_of_files = buff[0xBC];

//    printf("\nNumber of files = %d\n", number_of_files);

    for(j=1; j<=number_of_files; j++)
    {
        printf("\n#%d = %-20.20s", j, &buff[198+(j*64)]);
    }

    printf("\nInput file# to read ");
    file_number=1;//
    scanf("%d",&file_number);
//    printf("\nFile #%d chosen\n",file_number);
    strncpy(filename,&buff[198+(file_number*64)],20);
    filename[20]='\0';
    printf("Selected file \'%s\'\n", filename);


    d = 64+134 + file_number * 64; // directory entry
    p = buff[d - 5]; // total blocks
    q = p - 1 / 4; // pages?

//    printf("\nConsists of %d page(s)",p);
//    printf("\nUsing Q:%d sectors",q);
//    printf("\nd:0x%X",d);

// line 280
    for(i=0; i<=q; i++)
    {
        FT[i] = buff[d + 20 + 2 * i];
        FS[i] = buff[d + 21 + 2 * i];

//        printf("\nFT[%d]=%d",i,FT[i]);
//        printf(", FS[%d]=%d",i,FS[i]);
    }

// line 290
    for(n = 0; n <= q; n++)// for every sector, n
    {
        for(m  = 0; m <= 3; m++)// for every block, m
        {
            if(4*n+m+1 > p)break; // if pages + block > num blocks
//            printf("\nsector;n=%d, block;m=%d, total blocks;p=%d",n, m, p);
// line 300
            printf("\n<<<<<<<< page %d >>>>>>>>\n", 4 * n + m +1);
// line 310
            s=FS[n];
            if(t != FT[n])
            {
                t = FT[n];
                read_track(t, buff);
            }

 //           printf("\n(line310) n=%d, s=%d, m=%d)\n",n, s, m);

// line 320
            d=s*256 + m*64;
            g = buff[d];
            h = buff[d+1];
//            printf("\n(line320) d=0x%X, g=%d, h=%d",d,g,h);
// line 330
            for(i=0; i<=h; i++)
            {
                T[i]=buff[d+2*i+2];
                S[i]=buff[d+2*i+3];
//                printf("\nT[%d]=%d",i,T[i]);
//                printf(", S[%d]=%d",i,S[i]);
            }

// line 340
            for(i=0; i<=h; i++)
            {
//                printf("\nloop i=%d",i);
                if(T[i] != t)
                {
                    t = T[i];
                    read_track(t, buff);
                }
// line 350
                d=256*S[i];
                k=255;
                if(i == h)
                {
                    k=g;
                }

//                printf("\n(line350) d=0x%x, k=%d",d,k);

//                printf("\n[\n");

                for(j=0; j<k; j++)
                {

                    c = buff[d+j];
//printf("[c=%d]",c);
                    if(c<32)// line 370
                    {
                        if(c==0)y=0;// line 470
                        if(c>25)c=w[c-25];//line  480
                        if(c==21)c=142;//line 490
                        else c='*';//42;
                    }

                    else if(c>127)
                    { // line 510
                        y=1;
                        if(c==150)c='\n';//10
                        else if(c=151)c='\t';//9
                        else if(c==255)c='\r';//13
                        else if(c>145 && c<179)c=v[c-145];
                        else if(c==144)c='\"';//34;
                        else c='*';//42;
                    }

                    if(c==92)c=156;//line 380 pound sign

                    if(y)// line
                    {
                      printf("%c",c);
                    }
//                    else printf("[c=%d]",c);
                }
//                printf("\n]\n");

            }//end for i
        }// end for m
    }// end for n
    printf("\n<<<<<<<<  end   >>>>>>>>\n\n");
    return 0;
}
