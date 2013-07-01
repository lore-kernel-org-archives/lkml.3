Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3GAEap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 00:30:45 -0400
Received: from rrcs-24-173-105-85.sw.biz.rr.com ([24.173.105.85]:54004 "EHLO
	mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab3GAEao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 00:30:44 -0400
Message-ID: <51D10603.1080403@gentoo.org>
Date: Sun, 30 Jun 2013 23:30:59 -0500
From: Matthew Thode <prometheanfire@gentoo.org>
Reply-To: prometheanfire@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130628 Thunderbird/17.0.7
MIME-Version: 1.0
To: Luca Barbato <lu_zero@gentoo.org>
CC: linux-kernel@vger.kernel.org, linux-devel@vger.kernel.org,
        mjg59@srcf.ucam.org, torvalds@linux-foundation.org, kernel@gentoo.org,
        hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed), when
 booting with mem=300M
References: <51CC6CAE.6070401@gentoo.org> <51CC81A2.8040305@gentoo.org>
In-Reply-To: <51CC81A2.8040305@gentoo.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2WHAFXCSQBRGSWJGRQXNN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2WHAFXCSQBRGSWJGRQXNN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/27/2013 01:17 PM, Luca Barbato wrote:
> On 06/27/2013 06:47 PM, Matthew Thode wrote:
>> There is an early boot failure with linux-3.[9,10].??? when booting
>> using uefi on low memory systems.
>>
>> This seems like it might be hardware specific, I am running on a Lenov=
o
>> T520, running bios version 1.42, firmware rev 1.36.
>>
>=20
> Had the same problem with linux 3.10-rc1 and a stock mac book pro, I
> hadn't investigated much further though.
>=20
> lu
>=20
You had the problem where it was blank on boot (right after grub, no
kernel messages at all)?  Sounds like this might not be limited to just
Lenovo then.

mjg59, is there anything I can do to help move this bug forward?  I've
done all I can think of (even tried a serial expresscard slot for logging=
).

--=20
-- Matthew Thode (prometheanfire)


------enig2WHAFXCSQBRGSWJGRQXNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0QYKAAoJECRx6z5ArFrDgc4QAITXJNm3u+qfUVOQqXh2Yb9Q
73l6jsRUwA5iG3hxeKOnHoC8anC+qEsr78gb//6MKPv/xknLR2dj2efj1YNXfXcp
Z2uqt5HAgz0QdrTWb9t9AN35hoasE0CYLFnocGpQEp5PPPQl/QlMYxl3myHnjyPM
aooYHB0qYSUZHub+MHhog3Nkvdqu+5BLQ5Ytw1uU1iZQOqJRdsmfd2eYn/frehNK
KE77gJWjoIyYcoqYy+BmIZ60NHSEBfXdLdKvtk8tbRYnpujwtqcX2wqcpgIE+wNq
5e07VkBFXrsyS65YPgiAs0exFAehZkm61v8iOufMqjapZp8DLRlZMcalk9tlZBkL
iFmejL2ovx5K1aNcm1ylm2Ko4O+BfobVZSTAfkJmhsNWqY9GMsaE1hNPyOrMMelz
boM72bXqpqyHi5+gfAusPcIuVPW3RvTb+LmCQ/Kv1G/Xu/fHiBINsklQVC9nEzS0
yxursJz0oWJVDZRfycY0FIZZb1xG22u56dpoqcKRSVrnwlncncJ9jSTlcHjS5Kvr
HyBZfICInQQ5V/ogGFOqTBVgkwmYEqqUc/Vnqze6sVJ/nenvhHJaDOr2KT4YyRm/
NydwBQqAVci1k1yGOiU9pwFSCvdrNrWvHAz+TuHHqKVBTcI/iIISu6ZgclejlBGC
q1b9Pk45CTz41KnM42yd
=g1YJ
-----END PGP SIGNATURE-----

------enig2WHAFXCSQBRGSWJGRQXNN--
