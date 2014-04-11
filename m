Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaDKSsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:48:16 -0400
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:47388 "EHLO
	smtp1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754780AbaDKSsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:48:15 -0400
Message-ID: <534838E8.10005@grothoff.org>
Date: Fri, 11 Apr 2014 20:48:08 +0200
From: Christian Grothoff <christian@grothoff.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Alejandra Morales <alejandra.morales@tum.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cryogenic: Enabling Power-Aware Applications on Linux
References: <9E3F9C2076C45D4783F09B90D5BE77CE1AEF7A@BADWLRZ-SWMBX13.ads.mwn.de> <20140411101926.GA27234@amd.pavel.ucw.cz>
In-Reply-To: <20140411101926.GA27234@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/mixed;
 boundary="------------020405070801090704060600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020405070801090704060600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On 04/11/2014 12:19 PM, Pavel Machek wrote:
> Hi!
> 
>> Cryogenic is the result of my Master's Thesis, completed at the Technical University
>> of Munich under the supervision of Christian Grothoff. You can find more information
>> about Cryogenic at https://gnunet.org/cryogenic
> 
> Do you have any measurements how much power it actually saves?

Yes, it depends on the device, but we have demonstrated power
savings for two different types of devices using two different
measurement setups performed by two independent groups.  Some
of the measurements are available on the website, the second
set should become available "soon" (but we can already say that
for the scenario we measured, the savings are in the same range
as before).

> What would be cool for phones....

Yes, that's largely the point.

> "I'd like to download my mails from IMAP server in next 30
> minutes. But... it would be better done when I'm on 3G network with
> good signal (0.01W transmit power used for 3 seconds) than on GPRS
> with poor signal (2W transmit power for 4 minutes)..."

Well, that's not quite what the API would allow, especially as it
is obviously hard to predict that a different network will become
available.

--------------020405070801090704060600
Content-Type: application/pgp-keys;
 name="0x48426C7E.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0x48426C7E.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.12 (GNU/Linux)

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
bi50dW0uZGU+iGIEExECACIFAlIxk6cCGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4B
AheAAAoJEL9gcItIQmx+vb0An1MmoZCJS6g0yt3zYyGfJHsAKq5HAJ44c8HytmeP
5dZWXUN2FDTuVmrWaLQrQ2hyaXN0aWFuIEdyb3Rob2ZmIDxncm90aG9mZkBuZXQu
aW4udHVtLmRlPohiBBMRAgAiBQJSMZPOAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIe
AQIXgAAKCRC/YHCLSEJsfjscAJ9Pr+YACJEhAYpA6vuVRvxcow0lFgCgoqN6CY7G
F6eGRW/UsoApFOae8Em0JENocmlzdGlhbiBHcm90aG9mZiA8Z3JvdGhvZmZAdHVt
LmRlPohiBBMRAgAiBQJSMZPgAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAK
CRC/YHCLSEJsfmpHAKC1yUDliBcIb0feo+gKQfWrzHmYYgCeIWQ+4jhr6UddrDR0
GbaIewayoc25BA0ERYbybxAQAOAcuyco8qdniS2SuCP+Yar9bnu1ZDo2ccawMMLl
A7BRTZzml8Uv4cy3XXnEjuSk5HreFZsb9phJuYpSn7rb4lWs38VSTNy7dDc0Q5px
AI1ViFJP/hANV5LzdGPRqEzHGgi/fX41X3eERiWK+nHOfIF1oxfgof2Ef9pEY3/L
+pxHKV+c+xqOYzJiIIKbEgQ/meZwHh6KgG90aVx7diJt9ajOIGAQb9BCu2gjLmby
D0CbOpF05VWp/T20Y3e9Io/W7JD9aJGXPo0sAhOOf2z2GmY2nx2Yoy+UYLpGEbTj
jRHLChD6ioMmw0w4iEDWB9TN9aW5K1MrVwdo2VLj2knF06HKZIv8ZOahaZe6P7pU
ApcG2NxHnaWqH91mPdICSUeamhaB8sZ/ByXOOvQsTH12lXCMPVVdDw49chFHSJrK
dY210uO55OobVodx62TvzZTEUb06cjtaC3EIf+8G/mde8O5PapGVYHVlUoDbDdR8
TEmaBxHjHhPRBFzapWPHxdxzwb/kN+m1826o+8hZ/yCCDNGvXZHKmXpEv2xgLkYH
7j55JUeIc3BFhbjsb4JW1A+KsNu8sBT/a9JvYzIAdd7uUWtGrOWnB2i+IHNRxGHI
3bBgI2ueq6ZR1e4T6m56+sdjzCMJC930YTNeysGidA9du0HWis5XNI4rZYhP6MsB
iUmrAAMGD/sFT/8vmkvorHoXiKL3Kz/LJWsSEheApwHPq4HpqauMO58CKPKUSm5O
wgD7i6ofi62qmORIZ5CVPSC/CJCWEAGBJo7XZvZb2iDwl+mRdd+XQD3WUL5saamv
grFHWby07YvBO+x9BEWHMSNSLNzbhptEDI9cI4cccX848CYxLMwHspgQ2MoCxJWA
FwOy25Qmg+B8NB6E0jqR9nkE05uqZAdja/rs+0zmvJ9KxC9I/+fVwnY1w8dSleh6
s6ktT1nR5IVX0BtUmj5n5zaXDjrqf2dnlf1GbibsuXTad95wXHQo6eha+hg2mEJd
Mbn1kIT1lEkwxLnm27JKgv9FxCp09KmikC7BT+zqtJY5E9V4n648J3VknnqoXWuM
0QGYLsKzSXPHjqBotpy4ZS0YbVs9kNp0KgFBPg6N9pxgCPPB8lw85EOnbnfDn+E6
tBZkF8Nnv+pVxXxhb9Zhk1GEVpzQU8HnXBNl7A+i1vvJdnjP4TEr9F0X/F3YB4dS
1vX7bhxC6DK1Z18232vbowQlrIg2vzyH/9uQ+odHntcAA1Hi+txMkaJ5UzYWxyBj
IIt6rz2uFnA2/JskhtAYvp2Eix8LspT8wDhdW4nRBGw75omwHo5rHLNaWymvNGhN
Kje+DSwNwDC9dSC3p7xkHUPmVOYQeGsWdeMp1UNRvWeicaQ7HOuJYIhJBBgRAgAJ
BQJFhvJvAhsMAAoJEL9gcItIQmx+zJwAn3MrafB4VpPGwsPWugS1oylK3cfJAJ9b
SPkWd91LUq4ARWVVq5jaQopDGQ=3D=3D
=3DSAK6
-----END PGP PUBLIC KEY BLOCK-----

--------------020405070801090704060600--
