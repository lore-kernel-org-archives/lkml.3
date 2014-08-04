Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaHDO3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:29:52 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:44026 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbaHDO3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:29:50 -0400
Message-ID: <53DF98D7.7030106@gmail.com>
Date: Mon, 04 Aug 2014 10:29:43 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: Kernel Debugging Support
References: <Pine.LNX.4.44L0.1408041007330.1169-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1408041007330.1169-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.6
x-hashcash: 1:21:140804:stern@rowland.harvard.edu::62b535ff11dd2cd2c178594628ef4028:9f83658e816e88e8
x-hashcash: 1:21:140804:xerofoify@gmail.com::840b76157ba27ab63817200cd5d59c3:152ada9771d93022
x-hashcash: 1:21:140804:linux-kernel@vger.kernel.org::73972b13bb82297753e319babfb279ee:772702cb7b35544e
x-hashcash: 1:21:140804:linux-usb@vger.kernel.org::97ccdd06a439765fc46e135212274aa9:856599720f712480
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060102010609040400050700"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060102010609040400050700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-08-04 10:21, Alan Stern wrote:
> On Mon, 4 Aug 2014, Austin S Hemmelgarn wrote:
>=20
>> On 2014-08-02 09:48, Alan Stern wrote:
>>> On Sat, 2 Aug 2014, Nick Krause wrote:
>>>
>>>> Hey Sharp,
>>>> After reading around seems people want support for usb debugging in
>>>> kgdb or other usb based solutions.
>>>> If you and the other developers are able to help me out a bit as I a=
m
>>>> new I can definitively write this
>>>> area of kgdb support.
>>>
>>> Doesn't kgdb already support USB for debugging?
>>>
>>> Alan Stern
>>
>> AFAICT, on x86 it only supports using either a console capable serial
>> port (so you could do that over USB if you have USB serial console
>> support built-in, but most people I know don't compile that in, and in=

>> fact that is the only reason that i compile USB serial support in
>> instead of making it a module), and an AT compatible keyboard with any=

>> console option.
>=20
> What about with a USB debugging device (CONFIG_EARLY_PRINTK_DBGP)? =20
> That's how debugging over USB is _supposed_ to be done.
Yes, except those are really expensive, and on some it's pretty easy if
you don't know what you are doing to really screw things up.
>=20
>>  It would be really nice to have USB keyboard support in
>> there so that you don't have to reboot with special options and extra
>> hardware plugged in to get to the debugger, although doing something
>> that supports more than just the HID boot protocol will probably be tr=
icky.
>=20
> Is there some reason why kgdb doesn't simply use the kernel's input=20
> layer?  If there is, that same reason probably prevents it from using=20
> USB.
>=20
I believe it's to minimize the in-kernel dependencies.



--------------ms060102010609040400050700
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDgwNDE0Mjk0M1owIwYJKoZIhvcNAQkE
MRYEFKMBpKLjNrP3Urhywd+BkkGKw+tOMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAGNUnZHjZsmAOBgzd3VYRRjSUGJzGE4r6yai8Rx6h8iGo6ct
vFNALmvtY4qozmgX1j0uj/Z5GK5Ti4zKQUCgpVuUf0ITkO3odFx5KUGv9EU3LY1P5lnGQQVI
ZYW3UjDmzUEKlkZZUnM0CDmHDBHw8Jr6ddMIEa137ygADPBcC75LufPRrg0UoLouzI03RAIx
BS2FlaPVFqyRpKOMfUwIMjT6uZDvyAhZ7ma4IzRkC4ZmMlJ5y6symNWriN/cBROv6LsYlfK8
8AK6izNiIu3wxMwlOlT/4x77K09ohVIdQI8RDK0GmbVcReCo+LX4EIejdOvcbCON9mZYPfOg
I9Hd/dRaRlEBS/DlFAAFQldzZ0KBDUmvJPQtsvQfNsGyrEPaJnQhBomUNL4H4BJLWWUj42ml
XwKVpgTeEyVHObmkUX78Itk2KHa8FhsTfhLq+oMdLOgjwtyc7F10asqdNxg723ZSs2ihpILa
8iRMi0VXxCm+st4odgiuy8t2YpOjmtBhRC35bwhh81zrgiqNATlY44DzO2WSg7Qa8jdtoIsu
M463D1OWw3rO+F65ZDY/4Rp1602tR5eCO9FBRVxJ82WaYFRp0QMsIFoCeKus7tP847hKNfni
U6+bcBK+Z25m73l5pxKWaYR6TJO6Q+TQzp7JU+JNCgJyJDyiSB6BLE/g4evkAAAAAAAA
--------------ms060102010609040400050700--
