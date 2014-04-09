Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984AbaDISBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:01:19 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:60151 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440AbaDISBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:01:09 -0400
Message-ID: <53458ADE.70000@archlinux.org>
Date: Wed, 09 Apr 2014 20:01:02 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, matt.fleming@intel.com,
        ak@linux.intel.com, viro@zeniv.linux.org.uk, geert@linux-m68k.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org, hpa@zytor.com
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
References: <20140407173016.GU32556@tassilo.jf.intel.com> <5342E46B.4080603@archlinux.org> <53430646.40507@archlinux.org> <20140407204221.GW32556@tassilo.jf.intel.com> <CAL01qpvjZz-XnVT+S3E5E2XGcuFoetE5cwnArYfW-TwYZVKtKw@mail.gmail.com> <201404080646.BID87018.SOOVJMFOLFtQHF@I-love.SAKURA.ne.jp> <20140408121400.GI5222@console-pimps.org> <53444681.1070902@archlinux.org> <53445660.1010908@archlinux.org> <20140409082536.GJ5222@console-pimps.org> <5345051C.2060104@archlinux.org>
In-Reply-To: <5345051C.2060104@archlinux.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2bwx2l43MRCkdaP89Or14EpepeDoP0OJD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2bwx2l43MRCkdaP89Or14EpepeDoP0OJD
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 09.04.2014 10:30, schrieb Thomas B=E4chler:
> Am 09.04.2014 10:25, schrieb Matt Fleming:
>> On Tue, 08 Apr, at 10:04:48PM, Thomas B=E4chler wrote:
>>>
>>> Hello again Matt,
>>>
>>> with linux.git master, I cannot reproduce the problem at all (with or=

>>> without your patch). In fact, all the 0x0 CRCs on symbols are gone, a=
nd
>>> those were the symbols that were broken after all.
>>>
>>> FWIW, with your patch the kernel still boots.
>> =20
>> Could you try this version? It's against v3.14,
>=20
> I'll do that tonight and report back (now + ~10 hours).

Hello again Matt,

that patch seems to help. Thank you so much.

(I am going to apply this patch and backport dc53324060, too, so
everything should be in order then.)

Regards
Thomas

> In the meantime, I figured out which commit fixed the 0x00000000 symbol=

> CRCs in 3.14+, making this bug invisible - it was
> dc53324060f324e8af6867f57bf4891c13c6ef18 in the Linus tree.



--2bwx2l43MRCkdaP89Or14EpepeDoP0OJD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTRYrgAAoJEChPw0yOSxolFqUQAKnHGwX5R9K+xixkBghRsxU2
SrWcnWMo3wdbTBXAEVM0OpqqbnmFYl1cnxWxwnRZpXwJFLGFCQMOuMuJ9PYc3PCV
qaU2c1W0dZrFYk/mVp2pq06IcgttX6YyNW68Y0VrTu2/wDeYgOSl7JMTL8H0qRYx
8wPxxT9UnF5ZI5Is07Ai45HcxRVFqe8DLMiQBru4Fk9gu/SAGdy0nNbGt1evg61/
NivoFMVWTYdfj4sctSlyoC4lHI1To6kUk0b3wPXS1JXXM8J0OUYEQ7/OzFWJSTzz
sfkGXrOp0Ql1467ARPytOHSpe7oAV8HBzHxqSGM4ZSV80LuMXVN9zD+nzxdfqAF5
Yz81PD1lzoR7Z4za4TZ3qxOKCTz61oJrDNwHaG7yUpEace1qNX6rzSN/aykI9sFT
BT0rXbOvzFl60TRB0xENVO58L0CT1y4TGLVoIJluppshurMmX4Q2gguy9/EWgAVN
7ZLtsa4fDLnvS02KNrdH8AJofP9PWg4GhwVY6NwMAqfnZEN6VXeJPAL8Vgo9CAR+
2pRoI59TSeKGQ64iRLRXUL3WOqoL+Q8j3H2IGhsBRvWTewZ/hg5nIMk96q/g4TX3
EXumQYVx1icnysTly9SZVGbDG3lQs9I1d+yl+TFGEqlE7GtwZJh2A541DXCZJwbV
cB6b8qeH+aVYzTXvTO+A
=2gRe
-----END PGP SIGNATURE-----

--2bwx2l43MRCkdaP89Or14EpepeDoP0OJD--
