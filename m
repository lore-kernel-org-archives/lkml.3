Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3A2UNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:13:22 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:54311
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305Ab3A2UNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:13:18 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371Ic85fh542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz8275bhz2dh668h839hd25hf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h34h1155h)
X-WSS-ID: 0MHELHY-01-4HG-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Linux 3.8-rc4
Thread-Topic: Linux 3.8-rc4
Thread-Index: AQHN9cxhktnF6ESNpkuAIBoIzsaQJZhQNCEAgACn4tCABRQtgP//oN5AgAB+F4D//6LmYIAAax0AgABUMQCAAH8jgIAAu/gAgAhrfoCAAD7IYIAAyyMA//+iZkA=
Date: Tue, 29 Jan 2013 20:13:08 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DF0A37D@sausexdag04.amd.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
	<CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
	<CAKocOONuFvcik229+1B0oeaBnQG7seZPeYf99xqduFa6kBZhOw@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF083DE@sausexdag04.amd.com>
	<CAKocOOMxAYw-XO-6XGteKb8NyHDq4_BdZn2njUNBh+a73wrFGA@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF084EA@sausexdag04.amd.com>
	<CAKocOOOYKAZPH1+W3usfRUh68594e8YKqBUORo2c5bCCCYDh0A@mail.gmail.com>
	<CAKocOOOaWSvWZkhLNBx9u6M5nOu39wUgnS-a9Srsbp5BTcdh1A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF086E6@sausexdag04.amd.com>
	<CAKocOOMD9i7TtzoH3c2pDXqSRXV8RB1qmqp_QxftCpfK763CqA@mail.gmail.com>
	<CAKocOONFpPBQH=naKdmrXa1ijpzf=0jonKuUWbw3NhEeumfM=A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DF0A266@sausexdag04.amd.com>
 <CAKocOOPsvh=jOXLahe6ukjpyjOOqt9tRdwELxv8i0_Vi1xqQkA@mail.gmail.com>
In-Reply-To: <CAKocOOPsvh=jOXLahe6ukjpyjOOqt9tRdwELxv8i0_Vi1xqQkA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.8.62]
Content-Type: multipart/mixed;
	boundary="_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0A37Dsausexdag04amdc_"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0A37Dsausexdag04amdc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> Sent: Tuesday, January 29, 2013 2:11 PM
> To: Deucher, Alexander
> Cc: Linus Torvalds; Linux Kernel Mailing List
> Subject: Re: Linux 3.8-rc4
>=20
> On Tue, Jan 29, 2013 at 6:05 AM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
> >> -----Original Message-----
> >> I was out sick for a few days and finally picked this bisect backup
> >> again. I started at 3.7 tag instead of 3.8-rc1 that I did in the past
> >> and also did bisect at drivers/gpu/drm/radeon instead. Here are the
> >> results:
> >>
> >> 6253e4c75d96006c06b9ac8f417eba873de2497b is the first bad commit
> >> commit 6253e4c75d96006c06b9ac8f417eba873de2497b
> >> Author: Alex Deucher <alexander.deucher@amd.com>
> >> Date:   Wed Dec 12 14:30:32 2012 -0500
> >>
> >>     drm/radeon: improve mc_stop/mc_resume on r5xx-r7xx
> >>
> >>     Along the same lines of what was done for evergreen+
> >>     in the last kernel.
> >>
> >>     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> >>
> >> git bisect log attached.
> >>
> >
> > Try the attached patch.  I think it should fix the issue.  I just appli=
ed a similar
> patch for newer asics.
> >
> > Alex
> >
>=20
> I reverted 6253e4c75d96006c06b9ac8f417eba873de2497b and DMAR faults
> went away. Undid the revert and applied your new patch. DMAR faults
> are back again.
>=20
>=20
> [   25.158653] [drm] PCIE GART of 512M enabled (table at
> 0x0000000000040000).
> [   25.158715] radeon 0000:01:00.0: WB enabled
> [   25.158719] radeon 0000:01:00.0: fence driver on ring 0 use gpu
> addr 0x0000000008000c00 and cpu addr 0xffff88002f143c00
> [   25.158721] radeon 0000:01:00.0: fence driver on ring 3 use gpu
> addr 0x0000000008000c0c and cpu addr 0xffff88002f143c0c
>=20
> A few observations and questions about r600_startup() code sequence:
>=20
> I notice DMAR faults right after
>=20
> [drm] Loading RV620 Microcode message which is from
> r600_init_microcode(). This routine does a series of
> request_firmware() calls. btw. don't see release_firmware() calls in
> regular code path, only from error legs in r600_init_microcode().
>=20
> However, this routine doesn't do any loading yet. When this routine
> returns, I am assuming request_firmware() step isn't complete yet
> based on my reading request_firmware() interface. At this point
> r600_startup() keeps chugging along, and does r600_mc_program() which
> in turn calls rv515_mc_stop() which was changed with the
> 6253e4c75d96006c06b9ac8f417eba873de2497b commit.
>=20
> I am thinking the changes somehow eliminated a wait or delay that used
> be there for request_firmware() step to complete (?)
>=20
> I can see from dmesg that the faults occur right after:
>=20
> r600_init_microcode(rdev);
>=20
> and stop before r600_pcie_gart_enable()

r600_init_microcode() doesn't actually touch the hardware it just calls req=
uest_firmware() to fetch the microcode images from disk.  The microcode doe=
sn't get loaded onto the hardware until r600_cp_load_microcode() much later=
 in the function.  I don't think the microcode has anything to do with this=
.

rv515_mc_stop() stops GPU memory clients (e.g., the displays) and blacks ou=
t the GPU memory controller so that we can change the location of VRAM with=
in the GPU's address space.  If one of the display controllers memory reque=
st stop requests takes too long to go through for some reason, it's possibl=
e that the display hardware may attempt to read from a GPU memory location =
no-longer backed by vram (since we changed the location of vram in r600_mc_=
program()) momentarily until the stop request goes through.  Does the attac=
hed updated version of the patch help?  Alternatively, you can try adding d=
elays to the end of rv515_mc_stop() and see if that helps.

Alex
=20

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0A37Dsausexdag04amdc_
Content-Type: application/octet-stream;
	name="0001-drm-radeon-fix-MC-blackout-on-r5xx-r7xx-v2.patch"
Content-Description: 0001-drm-radeon-fix-MC-blackout-on-r5xx-r7xx-v2.patch
Content-Disposition: attachment;
	filename="0001-drm-radeon-fix-MC-blackout-on-r5xx-r7xx-v2.patch"; size=3347;
	creation-date="Tue, 29 Jan 2013 20:07:04 GMT";
	modification-date="Tue, 29 Jan 2013 20:05:58 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxZWQyMjdiNGE2OTBkYTA3NWU2ZTkwNjhiYzE2MTMxZWRiZDAzYzk2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFR1ZSwgMjkgSmFuIDIwMTMgMDc6NTk6MDcgLTA1MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uOiBmaXggTUMgYmxhY2tvdXQgb24gcjV4eC1yN3h4ICh2MikKCkZvcmNlIHRo
ZSBjcnRjIG1lbSByZXF1ZXN0cyBvbi9vZmYgaW1tZWRpYXRlbHkgcmF0aGVyCnRoYW4gd2FpdGlu
ZyBmb3IgdGhlIGRvdWJsZSBidWZmZXJlZCB1cGRhdGVzIHRvIGtpY2sgaW4uClNlZW1zIHdlIG1p
c3MgdGhlIHVwZGF0ZSBpbiBjZXJ0YWluIGNvbmRpdGlvbnMuIEJhc2VkIG9uCmEgc2ltaWxhciBm
aXggZm9yIGV2ZXJncmVlbi4KCnYyOiB0YWtlIHRoZSBncnBoIGxvY2sgd2hlbiB1cGRhdGluZyB0
aGUgbmV3IGRpc3BsYXkKYmFzZSBhZGRyZXNzZXMuCgpSZXBvcnRlZC1ieTogU2h1YWggS2hhbiA8
c2h1YWhraGFuQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4YW5k
ZXIuZGV1Y2hlckBhbWQuY29tPgpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwotLS0KIGRyaXZl
cnMvZ3B1L2RybS9yYWRlb24vcjUwMF9yZWcuaCB8ICAgIDEgKwogZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9ydjUxNS5jICAgIHwgICAgOCArKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2Vy
dGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9yNTAwX3JlZy5oIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yNTAwX3JlZy5oCmluZGV4
IGVjNTc2YWEuLjUxNTlmMGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjUw
MF9yZWcuaAorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I1MDBfcmVnLmgKQEAgLTM1OCw2
ICszNTgsNyBAQAogI2RlZmluZSBBVklWT19EMUNSVENfU1RFUkVPX0NPTlRST0wgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIDB4NjBjNAogCiAjZGVmaW5lIEFWSVZPX0QxTU9ERV9NQVNURVJf
VVBEQVRFX01PREUgICAgICAgICAgICAgICAgICAgICAgICAgMHg2MGU0CisjZGVmaW5lIEFWSVZP
X0QxQ1JUQ19VUERBVEVfTE9DSyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMHg2MGU4
CiAKIC8qIG1hc3RlciBjb250cm9scyAqLwogI2RlZmluZSBBVklWT19EQ19DUlRDX01BU1RFUl9F
TiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDB4NjBmOApkaWZmIC0tZ2l0IGEvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9ydjUxNS5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ydjUx
NS5jCmluZGV4IDJiYjZkMGUuLmM3MzZiNGEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9y
YWRlb24vcnY1MTUuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3J2NTE1LmMKQEAgLTMw
NCw3ICszMDQsOSBAQCB2b2lkIHJ2NTE1X21jX3N0b3Aoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJk
ZXYsIHN0cnVjdCBydjUxNV9tY19zYXZlICpzYXZlKQogCQkJaWYgKCEodG1wICYgQVZJVk9fQ1JU
Q19ESVNQX1JFQURfUkVRVUVTVF9ESVNBQkxFKSkgewogCQkJCXJhZGVvbl93YWl0X2Zvcl92Ymxh
bmsocmRldiwgaSk7CiAJCQkJdG1wIHw9IEFWSVZPX0NSVENfRElTUF9SRUFEX1JFUVVFU1RfRElT
QUJMRTsKKwkJCQlXUkVHMzIoQVZJVk9fRDFDUlRDX1VQREFURV9MT0NLICsgY3J0Y19vZmZzZXRz
W2ldLCAxKTsKIAkJCQlXUkVHMzIoQVZJVk9fRDFDUlRDX0NPTlRST0wgKyBjcnRjX29mZnNldHNb
aV0sIHRtcCk7CisJCQkJV1JFRzMyKEFWSVZPX0QxQ1JUQ19VUERBVEVfTE9DSyArIGNydGNfb2Zm
c2V0c1tpXSwgMCk7CiAJCQl9CiAJCQkvKiB3YWl0IGZvciB0aGUgbmV4dCBmcmFtZSAqLwogCQkJ
ZnJhbWVfY291bnQgPSByYWRlb25fZ2V0X3ZibGFua19jb3VudGVyKHJkZXYsIGkpOwpAQCAtMzQ1
LDYgKzM0Nyw4IEBAIHZvaWQgcnY1MTVfbWNfcmVzdW1lKHN0cnVjdCByYWRlb25fZGV2aWNlICpy
ZGV2LCBzdHJ1Y3QgcnY1MTVfbWNfc2F2ZSAqc2F2ZSkKIAogCS8qIHVwZGF0ZSBjcnRjIGJhc2Ug
YWRkcmVzc2VzICovCiAJZm9yIChpID0gMDsgaSA8IHJkZXYtPm51bV9jcnRjOyBpKyspIHsKKwkJ
V1JFRzMyX1AoQVZJVk9fRDFHUlBIX1VQREFURSArIGNydGNfb2Zmc2V0c1tpXSwKKwkJCSBBVklW
T19EMUdSUEhfVVBEQVRFX0xPQ0ssIH5BVklWT19EMUdSUEhfVVBEQVRFX0xPQ0spOwogCQlpZiAo
cmRldi0+ZmFtaWx5ID49IENISVBfUlY3NzApIHsKIAkJCWlmIChpID09IDEpIHsKIAkJCQlXUkVH
MzIoUjcwMF9EMUdSUEhfUFJJTUFSWV9TVVJGQUNFX0FERFJFU1NfSElHSCwKQEAgLTM2Miw2ICsz
NjYsOCBAQCB2b2lkIHJ2NTE1X21jX3Jlc3VtZShzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldiwg
c3RydWN0IHJ2NTE1X21jX3NhdmUgKnNhdmUpCiAJCSAgICAgICAodTMyKXJkZXYtPm1jLnZyYW1f
c3RhcnQpOwogCQlXUkVHMzIoUl8wMDYxMThfRDFHUlBIX1NFQ09OREFSWV9TVVJGQUNFX0FERFJF
U1MgKyBjcnRjX29mZnNldHNbaV0sCiAJCSAgICAgICAodTMyKXJkZXYtPm1jLnZyYW1fc3RhcnQp
OworCQlXUkVHMzJfUChBVklWT19EMUdSUEhfVVBEQVRFICsgY3J0Y19vZmZzZXRzW2ldLAorCQkJ
IDAsIH5BVklWT19EMUdSUEhfVVBEQVRFX0xPQ0spOwogCX0KIAlXUkVHMzIoUl8wMDAzMTBfVkdB
X01FTU9SWV9CQVNFX0FERFJFU1MsICh1MzIpcmRldi0+bWMudnJhbV9zdGFydCk7CiAKQEAgLTM4
NCw3ICszOTAsOSBAQCB2b2lkIHJ2NTE1X21jX3Jlc3VtZShzdHJ1Y3QgcmFkZW9uX2RldmljZSAq
cmRldiwgc3RydWN0IHJ2NTE1X21jX3NhdmUgKnNhdmUpCiAJCWlmIChzYXZlLT5jcnRjX2VuYWJs
ZWRbaV0pIHsKIAkJCXRtcCA9IFJSRUczMihBVklWT19EMUNSVENfQ09OVFJPTCArIGNydGNfb2Zm
c2V0c1tpXSk7CiAJCQl0bXAgJj0gfkFWSVZPX0NSVENfRElTUF9SRUFEX1JFUVVFU1RfRElTQUJM
RTsKKwkJCVdSRUczMihBVklWT19EMUNSVENfVVBEQVRFX0xPQ0sgKyBjcnRjX29mZnNldHNbaV0s
IDEpOwogCQkJV1JFRzMyKEFWSVZPX0QxQ1JUQ19DT05UUk9MICsgY3J0Y19vZmZzZXRzW2ldLCB0
bXApOworCQkJV1JFRzMyKEFWSVZPX0QxQ1JUQ19VUERBVEVfTE9DSyArIGNydGNfb2Zmc2V0c1tp
XSwgMCk7CiAJCQkvKiB3YWl0IGZvciB0aGUgbmV4dCBmcmFtZSAqLwogCQkJZnJhbWVfY291bnQg
PSByYWRlb25fZ2V0X3ZibGFua19jb3VudGVyKHJkZXYsIGkpOwogCQkJZm9yIChqID0gMDsgaiA8
IHJkZXYtPnVzZWNfdGltZW91dDsgaisrKSB7Ci0tIAoxLjcuNy41Cgo=

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DF0A37Dsausexdag04amdc_--
