Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaHEM0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:26:07 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:50657 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbaHEM0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:26:05 -0400
Message-ID: <53E0CD59.10003@gmail.com>
Date: Tue, 05 Aug 2014 08:26:01 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: madduck@madduck.net
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Disabling physical RAM regions for testing
References: <20140805114010.GA14521@fishbowl.rw.madduck.net>
In-Reply-To: <20140805114010.GA14521@fishbowl.rw.madduck.net>
X-Enigmail-Version: 1.6
x-hashcash: 1:21:140805:madduck@madduck.net::cc24472c7f4f081eea0f6143ad5e8d13:b1e3f0083caed6bc
x-hashcash: 1:21:140805:linux-kernel@vger.kernel.org::4d7784ffe24ca46f33d16a3531305d6f:5aee510bce7e054e
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010704060309090103050508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010704060309090103050508
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-08-05 07:40, martin f krafft wrote:
> Hello,
>=20
> A NAS seems to be having RAM problems, leading me to want to swap
> out DIMMs until I found the offender; I'd rather not go to the rack
> every time I need to make a change.
>=20
> Is there a way to declare a DIMM unavailable to Linux with a boot
> parameter? There is mem=3D and memmap=3D but i cannot figure them out.
>=20
> I have two 4Gb DIMMs in there and I just want to disable one, then
> the other=E2=80=A6
>=20
> This is the e820 physical RAM map:
>=20
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] u=
sable
> [    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] r=
eserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e2000-0x00000000000fffff] r=
eserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bff8ffff] u=
sable
> [    0.000000] BIOS-e820: [mem 0x00000000bff9e000-0x00000000bff9ffff] r=
eserved
> [    0.000000] BIOS-e820: [mem 0x00000000bffa0000-0x00000000bffaa5ff] A=
CPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bffaa600-0x00000000bffdffff] A=
CPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bffe0000-0x00000000bfffffff] r=
eserved
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] r=
eserved
> [    0.000000] BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffffffff] r=
eserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000022fffffff] u=
sable
>=20
> But what do I do with those info?
>=20
The e820 is probably not what you want to be looking at.  I would
suggest looking into memory hot-plug/hot-remove support, IIRC the
hot-remove support allows you to bring a bank offline.


--------------ms010704060309090103050508
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAw8BRDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA1
MTIxNDEwMzJaFw0xNDExMDgxNDEwMzJaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDbLUaL
Gs4JTdU7sgr0MzD57CMUAv307ddC9pxooDMN3PiUvzEd5kLtBCh8KDB1wbMdfm4hte2rDd+j
hM1tIq67BvNbdDPztOcBZwT2/3OVyyG4B1ddCqUyt03zGKw6Y34eHNfapsZiiItX0GBNfjHU
Wv+WDo+XNha/WmGSSMv21HkftF9XA1KC9Bpr9JJI23MKK7T2g/7b3KoGZlx3ekLIJsF5B7+B
DMPPDqOHQbRnccyOHEMyhM13g6WoAbU+3aKYc+C/9UsYtDV+xlvBLWagky1acstD5wOA35V6
uDRbUhD+vOjuMRMCj9jJOIYqa6AeSagBjxRnisJr0RFzQ4f+NjGCHPaFTvRvbkiXh4q22doT
0SxbNBUm7B9ANugIOtS9/VQhTWKDi//WTqZQ7Ecl4yVJbMCUg/iaRHMCGS41vqMICPszRidW
rL04NwS9D2cREEY1y/xrNo0ZvKPZu6tLhxhPf7w+5rsN3+wWxGaR1hNpnVUT9AeacLKZO6W9
FsRT3Unkr91IhQATHTKYr4EAkjN/5lgvA+sxp5TxxsUnoJYrD8IHf8aYfJsAHMleBwx4xSeZ
tw/n5iIjJjFZq9IRZ1zQhK62p+a5vJ2vlJHjTgavhQrfb1pUOjbqsnI4ndQ5hNosL9el4Kxq
Yko+HsxVEmSwSsjq6cV2L3oz0z8NUwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAIokFPcW8+cO2Clu0Ei+ehAmQRBHfV5RWJ8aMVLXOCfiJX0ch
IjVSIt6I3uQaR4J1ZIAjCSPkbpfZQDaLoGFI5j8aYEQhOeKxrvOMzY9/aSUYabCJIhE/sX64
klFV0bzm+PR9cDMWeQ9BoZf0m8UROPSfDnrjEk+p04hGg3pAZMcSwCzxdb604NHjgHJmf2xG
UQVzQgC6Ek/BKat0xuPTuPmtPv9OicK75CPmLZKYW3rFpCD6bhb1mm+ROcCNhniRY2LYm9YN
QdlHQUzTFqj0tvuYrzNI3LNV4PjEfN8z6omPCT2Rq8/uKLseN+m8F0ioqm+cphqpmzKoDUpN
nePLkqDFUFWCeWRxSjBTy4IMVUfdNXriVGihH8hyIICQiOfmmBOzhzUifdomJuTGtoXRuHVT
R2f/YdrJrLnKI4f+Othdp7F3KhB4c6JiOnTEH5J8n9q3rFjt4MPRwcjIHMhmF5nZVQlgxEMo
1cPCmvG1D9tcgXbH79jjqydo9SDXhzLQob7axkzGRY96IstNcvoQ/UNsdPPfFMYlHtGz4TxT
DhBjv4ERskGmKBZrfmxkXkcuTV/gcykct6Xvw9YXb8WTL4qSYHSYk9fReVLgE/L4RBUpX2JJ
QvIR0AJLER165/aZlQXZtuJjnfxJtJTJZZ+Gor9h0G2kuR5Dy0JuYdBO4t4xggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFEMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDgwNTEyMjYwMVowIwYJKoZIhvcNAQkE
MRYEFL4hj82P8OWHEiN9jg9culGIzodTMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAHKv7dfu50k7Fv+8xAltCvdVmArAaf9lT9dtlg4qt9zMUSkR
70anDpxPJ3Q9SmyOOU1dDHAR/TfTLQpEDk4q/y1Xj33VBWZocv9Whvt+PtMNd0SnBgxHHkm9
qGE9kdAiRQJxGAag/Cw7mKnMOvlQPvSaQNU+6BYq+gNYKHzFZPd0P93I7Nn3YeFsdi4RxIB6
h1445LPvOEiz5Y6ts/GAKB58k4Pzx9QTm69yT0m505ajzwlltFdHVX4ow6Nq+UlQaxgX+Rr3
Anjis3ypaJOhkOvX/VNgeHqkD+cOkpdLWkpJiZuRl+QOHj6sAFHaxt53yFPcv2oIMqPcPSLG
vjwslOrWe8M897IqC/NY9JPkMIhUG3mgLPEMSy5Z3o4t6sD0xvfQ0qo+A94NYTrAxt8iFZQ4
AjbnqL502kxmpQ50zs6z9A9vhHrbBRzt1TsltmUKA0P/ZDY8Xb1KOvy7wQ2SEJDZ+t9hqCmZ
ZpbSKWNcJfy6EygxstpBNuRIMMQzCCAAR5JJ//35izZoeGS/PEiVctsLzzPpa03jqMDXH+/z
uZ+8DiIC390hDUbfqN4jR39zxMsygf+fAB5QXS+zIPDrbsXr1CcO4halCFrpCkkH3LYhX4Oj
QwORqMlgzS/r6qJHKm6HGhnBGqaVi8eNM587iLgVyco0ESkfYFvi+h08mUKLAAAAAAAA
--------------ms010704060309090103050508--
