#include <cstdlib>
#include <iostream>

using namespace std;

#define FILENAME "INPUT.TXT"

void docfile(int **&A, int &m, int &n);
int** xacdinhgiatri(int **A, int m, int n);
void caub_(int **A, int **B, int m, int n);
bool cauc_(int **A, int **B, int m, int n);
void deletes(int **A, int m, int n);

int check_bai2_(int A[], int n, int vt, int capso);
int bai2_(int A[], int n)

int main(int argc, char *argv[])
{
    int **A, m, n;
	docfile(A, m, n);
	
	// xac dinh gia tri cac o khong min trong A
	int **B = xacdinhgiatri(A, m, n);
	caub_(A, B, m, n);
	
	if (cauc_(A, B, m, n))
	{
       cout << "Bai min Hop le";
    } else {
           cout <<"Bai min KHONG hop le";
    }
	
	deletes(A, m, n);
	deletes(B, m, n);
	
	// BAI 2 CAU 2 -- TU NHAP MANG
	int A[100];
	n = 100;
	bai2_(A, n);
	
    
    system("PAUSE");
    return EXIT_SUCCESS;
}

void docfile(int **&A, int &m, int &n)
{
	FILE *fi;
	fopen_s(&fi, FILENAME, "r");

	if (fi == 0)
	{
		cout<<"Khong the mo file\n";
		fclose(fi);
		return;
	}

	fscanf(fi, "%d", &m);
	fscanf(fi, "%d", &n);
	A = new int*[m];

	for (int i = 0; i < m; i++)
	{

		A[i] = new int[n];
	}

	for (int i = 0; i < m; i++)
	{
		for (int j = 0; j < n; j++)
		{
			fscanf(fi, "%d", &A[i][j]);
		}
	}
	fclose(fi);
}


//Dem min toan ma tran
int** xacdinhgiatri(int **A, int m, int n)
{
	int **KQ;
	KQ = new int*[m];
	for (int i = 0; i < m; i++)
	{
		KQ[i] = new int[n];
	}

	int **TEMP;
	TEMP = new int*[m+2];
	for (int i = 0; i < m+2; i++)
	{

		TEMP[i] = new int[n+2];
	}
	// Tao ma tran lon lon hon bao ben ngoai bang 0
	for (int i = 0; i < m+2; i++)
	{
		for (int j = 0; j < n+2; j++)
		{
			if (i == 0 || i == m+1 || j == 0 || j == n+1)
			{
				TEMP[i][j] = 0;
			}
		}
	}

	int k = 1, q = 1;
	for (int i = 0; i < m; i++)
	{
		q = 1;
		for (int j = 0; j < n; j++)
		{
			TEMP[k][q++] = A[i][j];
		}
		k++;
	}

	int dem = 0;
	k = 0; q = 0;
	for (int i = 1; i < m+1; i++)
	{
		q = 0;
		for (int j = 1; j < n+1; j++)
		{
			dem = 0;
			if (TEMP[i][j] == 0)
			{
				if (TEMP[i][j+1] == -1)
					dem++;
				if (TEMP[i][j-1] == -1)
					dem++;
				if (TEMP[i+1][j-1] == -1)
					dem++;
				if (TEMP[i+1][j] == -1)
					dem++;
				if (TEMP[i+1][j+1] == -1)
					dem++;
				if (TEMP[i-1][j+1] == -1)
					dem++;
				if (TEMP[i-1][j] == -1)
					dem++;
				if (TEMP[i-1][j-1] == -1)
					dem++;
				KQ[k][q++] = dem;
			}
			else
			{
				KQ[k][q] = A[k][q++];
			}
			//cout << KQ[k][q-1] <<" ";
		}
		k++;
		//cout <<endl;
	}
	deletes(TEMP, m+2, n+2);

	return KQ;
}

void caub_(int **A, int **B, int m, int n)
{
     cout << "Nhap: ";
     int i, j;
     do {
         do {
            cin >> i >> j;
         } while((i < 0 || i >= m) || (j < 0 || j >= n));
         
         if (A[i][j] != -1)
         {
            return;
         }
         
         bool result = A[i][j] == B[i][j] ? true : false;
         
         if (result)
         {
            cout <<"TRUE";
         } else {
           cout << "FALSE";
         }
     } while(true);
}

bool cauc_(int **A, int **B, int m, int n)
{
     for (int i = 0; i < m; i++)
     {
         for (int j = 0; j < n; j++)
         {
             if (A[i][j] != B[i][j])
             {
                return false;
             }
         }
     }
     return true;
}

void deletes(int **A, int m, int n)
{
	for (int i = 0; i < m; i++)
	{
		delete[] A[i];
	}
	delete[] A;
}

int bai2_(int A[], int n)
{
     if (n < 3)
     {
        return 0;
     }
     
     int capso = A[1] - A[0];
     int vt = 2;
     return check_bai2_(A, n, vt, capso);
     
}

int check_bai2_(int A[], int n, int vt, int capso) {
     if (vt >= n) {
        return 1;
     }
     
     if (A[vt] - A[vt-1] != capso) {
           return 0;
     }
     return check_bai2_(A, n, ++vt, capso);
}
