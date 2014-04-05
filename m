Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaDEVrM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:47:12 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:40356 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaDEVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:47:11 -0400
Message-ID: <534079D8.6020705@archlinux.org>
Date: Sat, 05 Apr 2014 23:47:04 +0200
From: =?UTF-8?B?VGhvbWFzIELDpGNobGVy?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, ak@linux.intel.com
CC: viro@ZenIV.linux.org.uk, geert@linux-m68k.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        tpowa@archlinux.org
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
References: <5339F739.2060207@archlinux.org>	<20140331233450.GI32556@tassilo.jf.intel.com>	<5339FC62.8060207@archlinux.org>	<20140405011332.GR32556@tassilo.jf.intel.com>	<5340134B.4010705@archlinux.org> <201404060223.FJI17489.LFMOVtOSFQFOHJ@I-love.SAKURA.ne.jp>
In-Reply-To: <201404060223.FJI17489.LFMOVtOSFQFOHJ@I-love.SAKURA.ne.jp>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4hnEaNKncD8FN3bVV7g10VNGrNXEn7OB1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4hnEaNKncD8FN3bVV7g10VNGrNXEn7OB1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 05.04.2014 19:23, schrieb Tetsuo Handa:
> Thomas B=E8=87=98hler wrote:
>>>> For convenience, here is a copy-and-paste of the full text:
>>>
>>> I did some experiments know and I can't find any 32bit modules=20
>>> that do not load with 32bit MODVERSIONS on or off with=20
>>> a current tree.
>>>
>>> Do you have a specific config?
>>> Specific compiler version?
>>
>> Using gcc 4.8 from Arch Linux with the configuration at [1] and Linux =
3.14.
>>
>> [1]
>> https://projects.archlinux.org/svntogit/packages.git/tree/trunk/config=
?h=3Dpackages/linux
>>
>=20
> I installed ArchLinux i686 and compiled
> https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.14.tar.xz using [1=
]
> as of commit bbf3d68a without any changes.
>=20
> It seems to me that everything is working well.
> Which modules you cannot load?

If I remove the revert of the offending commit, it fails loading ext4,
among others.



--4hnEaNKncD8FN3bVV7g10VNGrNXEn7OB1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTQHnaAAoJEChPw0yOSxol4NYQAKFvpxfNSYGIqrNWwrZ8jgBm
By+u3QOsLRi60IqnKXMCh/B0M2zbVoQVwDHb/g+ko/OgXTzAa+UZJ9x14RkDH4aI
fQg+thKwpwKEukFNSLo7C9joJ97NlzZZxvQGDIjD4OGNQCMbuFvnNtK0eIn2Ibkh
vK1ANxQ6eEli/p0rFVtl8HuJh7XtORI6W39/vzywgzuoDOSIeyg6Mi1he2vFjG3s
iII8iNDIrvahkglK3saVdVax0qS/0no4mQvG6dkxgOWgzGuc+lXMlHMjsLWjMcUa
uSoNkxsQPuv2e1lStciH+QPOD/n3uSp0SW7b9KJawsaYF9wzSGXsXZ/AoX913OvO
7H8kDnlwMcpwBkUehcxkmV2is5S4f8F8GNb3NrAFpl3ILBBQej7YZrLwSUYj/AU6
1YT7slfOcBbxJYucaYYm0l4RlWx4d+SiwkVH0icrzSyq/d0dGaftz77VbsIhg4i4
X+fW6UTAzRp4rm6qByBiGVX03Sondonp1bglkN2RVZSjIBJvMnC57u4N9obf5+za
LNdz/JHyGNMiJoeVdbSu2ypWc5K+SdUNc44UZ48+OCFfz6Um/1zDND+FRjucuFvN
wzX9Z2rF3/CmKvqfTQ7i9HRX1METt8pwRv9H3+9a51iA0MLAddPFuETsza03ZpSV
mP2fl8w5yFiW+MjXct/r
=FwJM
-----END PGP SIGNATURE-----

--4hnEaNKncD8FN3bVV7g10VNGrNXEn7OB1--
