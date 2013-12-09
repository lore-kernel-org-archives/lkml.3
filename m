Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289Ab3LIKTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:19:44 -0500
Received: from multi.imgtec.com ([194.200.65.239]:44399 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758733Ab3LIKTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:19:42 -0500
Message-ID: <52A5990E.2080808@imgtec.com>
Date: Mon, 9 Dec 2013 10:18:54 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/zswap.c: add BUG() for default case in zswap_writeback_entry()
References: <52A53024.9090701@gmail.com> <52A5935A.4040709@imgtec.com> <52A5973A.7020509@gmail.com>
In-Reply-To: <52A5973A.7020509@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="qAXefV6503UIGO1BfqDUiEx9ScgrRbLn9"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_12_09_10_19_05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qAXefV6503UIGO1BfqDUiEx9ScgrRbLn9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/12/13 10:11, Chen Gang wrote:
>> Since the metag compiler is stuck on an old version (gcc 4.2.4), which=

>> is wrong to warn in this case, and newer versions of gcc don't appear =
to
>> warn about it anyway (I just checked with gcc 4.7.2 x86_64), I have no=

>> objection to this warning remaining in the metag build.
>>
>=20
> Do you try "EXTRA_CFLAGS=3D-W" with gcc 4.7.2? I guess it will report t=
he
> warning too, I don't feel the compiler is smart enough (except it lets
> the long function zswap_get_swap_cache_page really inline)  :-)

EXTRA_CFLAGS=3D-W on gcc 4.7.2 gives me plenty of pointless unused
parameter warnings when compiling mm/zswap.o, but not the warning you're
trying to silence.

Cheers
James


--qAXefV6503UIGO1BfqDUiEx9ScgrRbLn9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJSpZkUAAoJEKHZs+irPybf0aIP/ioeotyiGtG5UOKC35190G+0
TcVc8InYNM/1U83mSUh8z3fqXbYw/S5xS12JoyFNyytKIH0lhzFBSLWjs7g6AVkg
l+GOPMVjsJbxQWHKgG3eBNPwCqpzmwUF4iuDg4LzxKTftUsMd2CJR2APopcapVLx
4CWmu957fnFSvU0eJ/TgizsBsuJI+jSz31yypb0jvXZEUK0iXe9hoTu4THJBhWm6
S8yx4gdnQHhaNdPC6JxceTGPUpknhwHBVCQQpIOOGNi91qgka4Oz2isY/2A1mYuI
xYq+fInM+ry8N+NKAP0PtwBNOwQ5GLNi5spJ+EGfbtSEvy/tYTsqol7Ws5Bpj8Tq
hQtSOGk8gJQSVqXv9PGoIGiCZ9mF5DdUXiX/LoUxfbaEsrvA57+0PL/C/H76+VXA
y4CG+j8uDQJYtpr4swpSbnJRwcNg0Zv3Ua+AXl1r4j8nFRJgXsso1qm+zC20ey9v
CFrXGWV/AWPLunUCqv8Pj5QgDDrlW6+ZtZn3d2A6hrJbPsHPMQbUzVoPiZQ1sKtt
NsKwZBGnrWaLzrhaPTrqFIPxWRuuRUakWRwioJkfxDqQEGoyr/PPkbSN7VNz8ErN
tIXZKzxWachqMGiCNuI8g3wSeweeCcUGzgVG2KK/MaAfRSMgMtiZxnfrB1esiTrv
IMk0e24wLORHDedE6jQd
=dEBm
-----END PGP SIGNATURE-----

--qAXefV6503UIGO1BfqDUiEx9ScgrRbLn9--

