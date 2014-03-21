Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaCUTv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:51:27 -0400
Received: from mail.ovgu.de ([141.44.1.66]:32833 "EHLO mail.ovgu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaCUTvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:51:08 -0400
Message-ID: <532C97DF.9010201@st.ovgu.de>
Date: Fri, 21 Mar 2014 20:49:51 +0100
From: Matthias Graf <matthias.graf@st.ovgu.de>
Organization: student.uni-magdeburg.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
References: <532C727F.1080803@st.ovgu.de> <20140321172742.GA2846@pd.tnic>
In-Reply-To: <20140321172742.GA2846@pd.tnic>
X-Enigmail-Version: 1.6
OpenPGP: id=BE42F9BD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="khBbkbBJjeQaQ6tBqI3rSRbLhdHAGfXRj"
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 HTML_00_01 0.05, HTML_00_10 0.05, LINES_OF_YELLING_3 0.05, BODY_SIZE_10000_PLUS 0, RDNS_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_SPECIFIC 0, TXT_ATTACHED 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __C230066_P5 0, __CP_MEDIA_BODY 0, __CT 0, __CTYPE_HAS_BOUNDARY 0, __CTYPE_MULTIPART 0, __FORWARDED_MSG 0, __HAS_FROM 0, __HAS_MSGID 0, __INT_PROD_COMP 0, __IN_REP_TO 0, __LINES_OF_YELLING 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __RDNS_POOLED_10 0, __SANE_MSGID 0, __SUBJ_ALPHA_NEGATE 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0'
X-Spam-Score: Gauge=IIIIIIII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--khBbkbBJjeQaQ6tBqI3rSRbLhdHAGfXRj
Content-Type: multipart/mixed;
 boundary="------------000007070607060206060403"

This is a multi-part message in MIME format.
--------------000007070607060206060403
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

(Please CC me on all replies)

mcelog output for all mces:



Hardware event. This is not a software error.
CPU 3 BANK 0
MCG status:RIPV MCIP
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access
Request-did-not-timeout Error
BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
timeout BINIT (ROB timeout). No micro-instruction retired for some time
STATUS b200004000000800 MCGSTATUS 5


Hardware event. This is not a software error.
CPU 3 BANK 5
MCG status:RIPV MCIP
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal Timer error
STATUS b200220024080400 MCGSTATUS 5


Hardware event. This is not a software error.
CPU 1 BANK 0
MCG status:MCIP
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access
Request-did-not-timeout Error
BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
timeout BINIT (ROB timeout). No micro-instruction retired for some time
STATUS b200004000000800 MCGSTATUS 4


Hardware event. This is not a software error.
CPU 1 BANK 5
MCG status:MCIP
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal Timer error
STATUS b200220010040400 MCGSTATUS 4


Hardware event. This is not a software error.
CPU 2 BANK 0
MCG status:MCIP
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access
Request-did-not-timeout Error
BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
timeout BINIT (ROB timeout). No micro-instruction retired for some time
STATUS b200004000000800 MCGSTATUS 4


Hardware event. This is not a software error.
CPU 2 BANK 5
MCG status:MCIP
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal Timer error
STATUS b200221010040400 MCGSTATUS 4

Hardware event. This is not a software error.
CPU 0 BANK 5
MCG status:RIPV MCIP
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: Internal Timer error
STATUS b200221024080400 MCGSTATUS 5


Hardware event. This is not a software error.
CPU 0 BANK 0
MCG status:RIPV MCIP
MCi status:
Uncorrected error
Error enabled
Processor context corrupt
MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access
Request-did-not-timeout Error
BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
timeout BINIT (ROB timeout). No micro-instruction retired for some time
STATUS b200004000000800 MCGSTATUS 5



Am 21.03.2014 18:27, schrieb Borislav Petkov:
> On Fri, Mar 21, 2014 at 06:10:23PM +0100, Matthias Graf wrote:
>> Please CC me on replies.
>>
>> [1.] Kernel panic: Fatal Machine Check after booting >=3D
>> 3.13.5-101.fc19.x86_64; 3.12.11-201.fc19.x86_64 works fine!
>> [2.] Screen freezes a few seconds after Gnome appears. The error messa=
ge
>> (see attachement) is seldom still printed to the screen. Booting
>> 3.12.11-201 with otherwise the same setup, I do not see the panic.
>> Booting on different hardware (my laptop) does not produce the panic. =
I
>> also notice low frames per seconds after gnome started up, right befor=
e
>> the panic occures. I therefore suppose this is graphics hardware relat=
ed.
>> [3.] Fatal Machine Check Exception, RIP Inexact, apic_timer_interrupt,=

>> Kernel panic
>> [4.] 3.13.6-100.fc19.x86_64 && 3.13.5-103.fc19.x86 && 3.13.5-101.fc19.=
x86_64
>> [5.] OCRed: (see Attachement for photo)
>>
>> Started Accounts Service.
>> [ 34.348483] mce: [Hardware Error]: CPU 3: Machine Check Exception: 5 =
Bank 8: bZ88884888888888
>> [ 44.468168] mce: [Hardware Error]: HIP ?IHEX=EF=AC=81CT? 18:<ffffffff=
816881f8> {apicgtimer_interrupt+8x8/8x88}
>> I 44.468168] mce: [Hardware Error]: TSC 36S??8ad8c
>> f 44.468168] mce: [Hardware Error]: PROCESSOR 8:6fb TIM 138471666? SOC=
KET 8 HPIC 2 microcode ba
>> I 44.468168] mce: [Hardware Error]: Run the above through 'mcelog ~~as=
cii=E2=80=99
>=20
> This looks like you had some text recognition done on the jpeg. :-)
>=20
> Please correct the error message to be exactly as in the jpeg and run i=
t
> through mcelog --ascii to see what that bank 8 is trying to tell us.
>=20
> Thanks.
>=20

--------------000007070607060206060403
Content-Type: text/plain; charset=UTF-8;
 name="mce.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mce.txt"

WyAzNC4zNDg0ODNdIG1jZTogW0hhcmR3YXJlIEVycm9yXTogQ1BVIDM6IE1hY2hpbmUgQ2hl
Y2sgRXhjZXB0aW9uOiA1IEJhbmsgMDogYjIwMDAwNDAwMDAwMDgwMApbIDQ0LjQ2ODE2OF0g
bWNlOiBbSGFyZHdhcmUgRXJyb3JdOiBSSVAgIUlORVhBQ1QhIDEwOjxmZmZmZmZmZjgxNjkw
MWYwPiB7YXBpY190aW1lcl9pbnRlcnJ1cHQrMHgwLzB4ODB9ClsgNDQuNDY4MTY4XSBtY2U6
IFtIYXJkd2FyZSBFcnJvcl06IFRTQyAzNjU3NzlhZDBjClsgNDQuNDY4MTY4XSBtY2U6IFtI
YXJkd2FyZSBFcnJvcl06IFBST0NFU1NPUiAwOjZmYiBUSU1FIDEzOTQ3MTY2NjcgU09DS0VU
IDAgQVBJQyAyIG1pY3JvY29kZSBiYQpbIDQ0LjQ2ODE2OF0gbWNlOiBbSGFyZHdhcmUgRXJy
b3JdOiBSdW4gdGhlIGFib3ZlIHRocm91Z2ggJ21jZWxvZyAtLWFzY2lpJwpbIDQ0LjQ2ODE2
OF0gbWNlOiBbSGFyZHdhcmUgRXJyb3JdOiBDUFUgMzogTWFjaGluZSBDaGVjayBFeGNlcHRp
b246IDUgQmFuayA1OiBiMjAwMjIwMDI0MDgwNDAwClsgNDQuNDY4MTY4XSBtY2U6IFtIYXJk
d2FyZSBFcnJvcl06IFJJUCAhSU5FWEFDVCEgMTA6PGZmZmZmZmZmODE2OTAxZjA+IHthcGlj
X3RpbWVyX2ludGVycnVwdCsweDAvMHg4MH0KWyA0NC40NjgxNjhdIG1jZTogW0hhcmR3YXJl
IEVycm9yXTogVFNDIDM2NTc3OWFkMGMKWyA0NC40NjgxNjhdIG1jZTogW0hhcmR3YXJlIEVy
cm9yXTogUFJPQ0VTU09SIDA6NmZiIFRJTUUgMTM5NDcxNjY2NyBTT0NLRVQgMCBBUElDIDIg
bWljcm9jb2RlIGJhClsgNDQuNDY4MTY4XSBtY2U6IFtIYXJkd2FyZSBFcnJvcl06IFJ1biB0
aGUgYWJvdmUgdGhyb3VnaCAnbWNlbG9nIC0tYXNjaWknClsgNDQuNDY4MTY4XSBtY2U6IFtI
YXJkd2FyZSBFcnJvcl06IENQVSAxOiBNYWNoaW5lIENoZWNrIEV4Y2VwdGlvbjogNCBCYW5r
IDA6IGIyMDAwMDQwMDAwMDA4MDAKWyA0NC40NjgxNjhdIG1jZTogW0hhcmR3YXJlIEVycm9y
XTogVFNDIDM2NTc3OWFkNDIKWyA0NC40NjgxNjhdIG1jZTogW0hhcmR3YXJlIEVycm9yXTog
UFJPQ0VTU09SIDA6NmZiIFRJTUUgMTM5NDcxNjY2NyBTT0NLRVQgMCBBUElDIDMgbWljcm9j
b2RlIGJhClsgNDQuNDY4MTY4XSBtY2U6IFtIYXJkd2FyZSBFcnJvcl06IFJ1biB0aGUgYWJv
dmUgdGhyb3VnaCAnbWNlbG9nIC0tYXNjaWknClsgNDQuNDY4MTY4XSBtY2U6IFtIYXJkd2Fy
ZSBFcnJvcl06IENQVSAxOiBNYWNoaW5lIENoZWNrIEV4Y2VwdGlvbjogNCBCYW5rIDU6IGIy
MDAyMjAwMTAwNDA0MDAKWyA0NC40NjgxNjhdIG1jZTogW0hhcmR3YXJlIEVycm9yXTogVFND
IDM2NTc3OWFkNDIKWyA0NC40NjgxNjhdIG1jZTogW0hhcmR3YXJlIEVycm9yXTogUFJPQ0VT
U09SIDA6NmZiIFRJTUUgMTM5NDcxNjY2NyBTT0NLRVQgMCBBUElDIDMgbWljcm9jb2RlIGJh
ClsgNDQuNDY4MTY4XSBtY2U6IFtIYXJkd2FyZSBFcnJvcl06IFJ1biB0aGUgYWJvdmUgdGhy
b3VnaCAnbWNlbG9nIC0tYXNjaWknClsgNDQuNDY4MTY4XSBtY2U6IFtIYXJkd2FyZSBFcnJv
cl06IENQVSAyOiBNYWNoaW5lIENoZWNrIEV4Y2VwdGlvbjogNCBCYW5rIDA6IGIyMDAwMDQw
MDAwMDA4MDAKWyA0NC40NjgxNjhdIG1jZTogW0hhcmR3YXJlIEVycm9yXTogVFNDIDM2NTc3
OWFlYWEKWyA0NC40NjgxNjhdIG1jZTogW0hhcmR3YXJlIEVycm9yXTogUFJPQ0VTU09SIDA6
NmZiIFRJTUUgMTM5NDcxNjY2NyBTT0NLRVQgMCBBUElDIDEgbWljcm9jb2RlIGJhClsgNDQu
NDY4MTY4XSBtY2U6IFtIYXJkd2FyZSBFcnJvcl06IFJ1biB0aGUgYWJvdmUgdGhyb3VnaCAn
bWNlbG9nIC0tYXNjaWknClsgNDQuNDY4MTY4XSBtY2U6IFtIYXJkd2FyZSBFcnJvcl06IENQ
VSAyOiBNYWNoaW5lIENoZWNrIEV4Y2VwdGlvbjogNCBCYW5rIDU6IGIyMDAyMjEwMTAwNDA0
MDAKWyA0NC40NjgxNjhdIG1jZTogW0hhcmR3YXJlIEVycm9yXTogVFNDIDM2NTc3OWFlYWEK
WyA0NC40NjgxNjhdIG1jZTogW0hhcmR3YXJlIEVycm9yXTogUFJPQ0VTU09SIDA6NmZiIFRJ
TUUgMTM5NDcxNjY2NyBTT0NLRVQgMCBBUElDIDEgbWljcm9jb2RlIGJhClsgNDQuNDY4MTY4
XSBtY2U6IFtIYXJkd2FyZSBFcnJvcl06IFJ1biB0aGUgYWJvdmUgdGhyb3VnaCAnbWNlbG9n
IC0tYXNjaWknClsgNDQuNDY4MTY4XSBtY2U6IFtIYXJkd2FyZSBFcnJvcl06IENQVSAwOiBN
YWNoaW5lIENoZWNrIEV4Y2VwdGlvbjogNSBCYW5rIDU6IGIyMDAyMjEwMjQwODA0MDAKWyA0
NC40NjgxNjhdIG1jZTogW0hhcmR3YXJlIEVycm9yXTogUklQICFJTkVYQUNUISAxMDo8ZmZm
ZmZmZmY4MTY5MDFmMD4ge2FwaWNfdGltZXJfaW50ZXJydXB0KzB4MC8weDgwfQpbIDQ0LjQ2
ODE2OF0gbWNlOiBbSGFyZHdhcmUgRXJyb3JdOiBUU0MgMzY1Nzc5YWVjZQpbIDQ0LjQ2ODE2
OF0gbWNlOiBbSGFyZHdhcmUgRXJyb3JdOiBQUk9DRVNTT1IgMDo2ZmIgVElNRSAxMzk0NzE2
NjY3IFNPQ0tFVCAwIEFQSUMgMCBtaWNyb2NvZGUgYmEKWyA0NC40NjgxNjhdIG1jZTogW0hh
cmR3YXJlIEVycm9yXTogUnVuIHRoZSBhYm92ZSB0aHJvdWdoICdtY2Vsb2cgLS1hc2NpaScK
WyA0NC40NjgxNjhdIG1jZTogW0hhcmR3YXJlIEVycm9yXTogQ1BVIDA6IE1hY2hpbmUgQ2hl
Y2sgRXhjZXB0aW9uOiA1IEJhbmsgMDogYjIwMDAwNDAwMDAwMDgwMApbIDQ0LjQ2ODE2OF0g
bWNlOiBbSGFyZHdhcmUgRXJyb3JdOiBSSVAgIUlORVhBQ1QhIDEwOjxmZmZmZmZmZjgxNjkw
MWYwPiB7YXBpY190aW1lcl9pbnRlcnJ1cHQrMHgwLzB4ODB9ClsgNDQuNDY4MTY4XSBtY2U6
IFtIYXJkd2FyZSBFcnJvcl06IFRTQyAzNjU3NzlhZWNlClsgNDQuNDY4MTY4XSBtY2U6IFtI
YXJkd2FyZSBFcnJvcl06IFBST0NFU1NPUiAwOjZmYiBUSU1FIDEzOTQ3MTY2NjcgU09DS0VU
IDAgQVBJQyAwIG1pY3JvY29kZSBiYQpbIDQ0LjQ2ODE2OF0gbWNlOiBbSGFyZHdhcmUgRXJy
b3JdOiBSdW4gdGhlIGFib3ZlIHRocm91Z2ggJ21jZWxvZyAtLWFzY2lpJwpbIDQ0LjQ2ODE2
OF0gbWNlOiBbSGFyZHdhcmUgRXJyb3JdOiBNYWNoaW5lIGNoZWNrOiBQcm9jZXNzb3IgY29u
dGV4dCBjb3JydXB0ClsgNDQuNDY4MTY4XSBLZXJuZWwgcGFuaWMg4oCUIG5vdCBzeW5jaW5n
OiBGYXRhbCBNYWNoaW5lIGNoZWNrClsgNDQuNDY4MTY4XSBkcm1fa21zX2hlbHBlcjogcGFu
aWMgb2NjdXJyZWQsIHN3aXRjaGluZyBiYWNrIHRvIHRleHQgY29uc29sZQpbIDQ0LjQ2ODE2
OF0gUmVib290aW5nIGluIDMwIHNlY29uZHMuLgo=
--------------000007070607060206060403
Content-Type: text/plain; charset=UTF-8;
 name="mcelog.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mcelog.txt"

SGFyZHdhcmUgZXZlbnQuIFRoaXMgaXMgbm90IGEgc29mdHdhcmUgZXJyb3IuCkNQVSAzIEJB
TksgMCAKTUNHIHN0YXR1czpSSVBWIE1DSVAgCk1DaSBzdGF0dXM6ClVuY29ycmVjdGVkIGVy
cm9yCkVycm9yIGVuYWJsZWQKUHJvY2Vzc29yIGNvbnRleHQgY29ycnVwdApNQ0E6IEJVUyBM
ZXZlbC0wIExvY2FsLUNQVS1vcmlnaW5hdGVkLXJlcXVlc3QgR2VuZXJpYyBNZW1vcnktYWNj
ZXNzIFJlcXVlc3QtZGlkLW5vdC10aW1lb3V0IEVycm9yCkJRX0RDVV9SRUFEX1RZUEUgQlFf
RVJSX0hBUkRfVFlQRSBCUV9FUlJfSEFSRF9UWVBFCnRpbWVvdXQgQklOSVQgKFJPQiB0aW1l
b3V0KS4gTm8gbWljcm8taW5zdHJ1Y3Rpb24gcmV0aXJlZCBmb3Igc29tZSB0aW1lClNUQVRV
UyBiMjAwMDA0MDAwMDAwODAwIE1DR1NUQVRVUyA1CgoKSGFyZHdhcmUgZXZlbnQuIFRoaXMg
aXMgbm90IGEgc29mdHdhcmUgZXJyb3IuCkNQVSAzIEJBTksgNSAKTUNHIHN0YXR1czpSSVBW
IE1DSVAgCk1DaSBzdGF0dXM6ClVuY29ycmVjdGVkIGVycm9yCkVycm9yIGVuYWJsZWQKUHJv
Y2Vzc29yIGNvbnRleHQgY29ycnVwdApNQ0E6IEludGVybmFsIFRpbWVyIGVycm9yClNUQVRV
UyBiMjAwMjIwMDI0MDgwNDAwIE1DR1NUQVRVUyA1CgoKSGFyZHdhcmUgZXZlbnQuIFRoaXMg
aXMgbm90IGEgc29mdHdhcmUgZXJyb3IuCkNQVSAxIEJBTksgMCAKTUNHIHN0YXR1czpNQ0lQ
IApNQ2kgc3RhdHVzOgpVbmNvcnJlY3RlZCBlcnJvcgpFcnJvciBlbmFibGVkClByb2Nlc3Nv
ciBjb250ZXh0IGNvcnJ1cHQKTUNBOiBCVVMgTGV2ZWwtMCBMb2NhbC1DUFUtb3JpZ2luYXRl
ZC1yZXF1ZXN0IEdlbmVyaWMgTWVtb3J5LWFjY2VzcyBSZXF1ZXN0LWRpZC1ub3QtdGltZW91
dCBFcnJvcgpCUV9EQ1VfUkVBRF9UWVBFIEJRX0VSUl9IQVJEX1RZUEUgQlFfRVJSX0hBUkRf
VFlQRQp0aW1lb3V0IEJJTklUIChST0IgdGltZW91dCkuIE5vIG1pY3JvLWluc3RydWN0aW9u
IHJldGlyZWQgZm9yIHNvbWUgdGltZQpTVEFUVVMgYjIwMDAwNDAwMDAwMDgwMCBNQ0dTVEFU
VVMgNAoKCkhhcmR3YXJlIGV2ZW50LiBUaGlzIGlzIG5vdCBhIHNvZnR3YXJlIGVycm9yLgpD
UFUgMSBCQU5LIDUgCk1DRyBzdGF0dXM6TUNJUCAKTUNpIHN0YXR1czoKVW5jb3JyZWN0ZWQg
ZXJyb3IKRXJyb3IgZW5hYmxlZApQcm9jZXNzb3IgY29udGV4dCBjb3JydXB0Ck1DQTogSW50
ZXJuYWwgVGltZXIgZXJyb3IKU1RBVFVTIGIyMDAyMjAwMTAwNDA0MDAgTUNHU1RBVFVTIDQK
CgpIYXJkd2FyZSBldmVudC4gVGhpcyBpcyBub3QgYSBzb2Z0d2FyZSBlcnJvci4KQ1BVIDIg
QkFOSyAwIApNQ0cgc3RhdHVzOk1DSVAgCk1DaSBzdGF0dXM6ClVuY29ycmVjdGVkIGVycm9y
CkVycm9yIGVuYWJsZWQKUHJvY2Vzc29yIGNvbnRleHQgY29ycnVwdApNQ0E6IEJVUyBMZXZl
bC0wIExvY2FsLUNQVS1vcmlnaW5hdGVkLXJlcXVlc3QgR2VuZXJpYyBNZW1vcnktYWNjZXNz
IFJlcXVlc3QtZGlkLW5vdC10aW1lb3V0IEVycm9yCkJRX0RDVV9SRUFEX1RZUEUgQlFfRVJS
X0hBUkRfVFlQRSBCUV9FUlJfSEFSRF9UWVBFCnRpbWVvdXQgQklOSVQgKFJPQiB0aW1lb3V0
KS4gTm8gbWljcm8taW5zdHJ1Y3Rpb24gcmV0aXJlZCBmb3Igc29tZSB0aW1lClNUQVRVUyBi
MjAwMDA0MDAwMDAwODAwIE1DR1NUQVRVUyA0CgoKSGFyZHdhcmUgZXZlbnQuIFRoaXMgaXMg
bm90IGEgc29mdHdhcmUgZXJyb3IuCkNQVSAyIEJBTksgNSAKTUNHIHN0YXR1czpNQ0lQIApN
Q2kgc3RhdHVzOgpVbmNvcnJlY3RlZCBlcnJvcgpFcnJvciBlbmFibGVkClByb2Nlc3NvciBj
b250ZXh0IGNvcnJ1cHQKTUNBOiBJbnRlcm5hbCBUaW1lciBlcnJvcgpTVEFUVVMgYjIwMDIy
MTAxMDA0MDQwMCBNQ0dTVEFUVVMgNAoKSGFyZHdhcmUgZXZlbnQuIFRoaXMgaXMgbm90IGEg
c29mdHdhcmUgZXJyb3IuCkNQVSAwIEJBTksgNSAKTUNHIHN0YXR1czpSSVBWIE1DSVAgCk1D
aSBzdGF0dXM6ClVuY29ycmVjdGVkIGVycm9yCkVycm9yIGVuYWJsZWQKUHJvY2Vzc29yIGNv
bnRleHQgY29ycnVwdApNQ0E6IEludGVybmFsIFRpbWVyIGVycm9yClNUQVRVUyBiMjAwMjIx
MDI0MDgwNDAwIE1DR1NUQVRVUyA1CgoKSGFyZHdhcmUgZXZlbnQuIFRoaXMgaXMgbm90IGEg
c29mdHdhcmUgZXJyb3IuCkNQVSAwIEJBTksgMCAKTUNHIHN0YXR1czpSSVBWIE1DSVAgCk1D
aSBzdGF0dXM6ClVuY29ycmVjdGVkIGVycm9yCkVycm9yIGVuYWJsZWQKUHJvY2Vzc29yIGNv
bnRleHQgY29ycnVwdApNQ0E6IEJVUyBMZXZlbC0wIExvY2FsLUNQVS1vcmlnaW5hdGVkLXJl
cXVlc3QgR2VuZXJpYyBNZW1vcnktYWNjZXNzIFJlcXVlc3QtZGlkLW5vdC10aW1lb3V0IEVy
cm9yCkJRX0RDVV9SRUFEX1RZUEUgQlFfRVJSX0hBUkRfVFlQRSBCUV9FUlJfSEFSRF9UWVBF
CnRpbWVvdXQgQklOSVQgKFJPQiB0aW1lb3V0KS4gTm8gbWljcm8taW5zdHJ1Y3Rpb24gcmV0
aXJlZCBmb3Igc29tZSB0aW1lClNUQVRVUyBiMjAwMDA0MDAwMDAwODAwIE1DR1NUQVRVUyA1
Cgo=
--------------000007070607060206060403--

--khBbkbBJjeQaQ6tBqI3rSRbLhdHAGfXRj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTLJffAAoJELO00SK+Qvm9S8wH/jQKpQfPoehzccbbVSQZnERp
AXqtsIJNFSmffpAOG9atrkCCmbRYHFD8t+DTz9ckDNGejVCRxyESICpULJ06mgCp
mP0jA7zSv7A+aPyAYf7XGxEYq/fKThPXwsF4C7lH8597wkLybN81dfgKpHbTuuZi
uE0uydO3Lrh4VEssKoaTuBW/AeDlqF0/ivSopITU/oHppcVpMRfPeAfc7OAgNM2X
0vyrqi7YSDjr1ftI1TugoX5lR5ApNslmbIY4dAaUqC0UDKwjyXyVOtZS8ubvNbO2
rE82QfVK2lSJO8kZSRMlJSJqjMTOv5OGiDIb1qhvWDP6tgeeZIapJ1OhrgmczFM=
=7AJA
-----END PGP SIGNATURE-----

--khBbkbBJjeQaQ6tBqI3rSRbLhdHAGfXRj--
