Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaBWW4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 17:56:10 -0500
Received: from imp01.mtu.ru ([62.5.255.10]:52015 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbaBWW4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 17:56:08 -0500
X-Spam-Flag: NO
Message-ID: <530A7C58.2060009@pavlinux.ru>
Date: Mon, 24 Feb 2014 02:55:20 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.12-rt19
References: <20140223184727.GA12442@linutronix.de> <530A486A.2000802@pavlinux.ru> <530A4C00.5070205@pavlinux.ru> <alpine.DEB.2.02.1402232211300.21251@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402232211300.21251@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="aNStfUbCoKTkdWGJM24I4NvHrmiNwNg2R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aNStfUbCoKTkdWGJM24I4NvHrmiNwNg2R
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

24.02.2014 01:13, Thomas Gleixner =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Sun, 23 Feb 2014, Pavel Vasilyev wrote:
>> 23.02.2014 23:13, Pavel Vasilyev =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>
>>> But not  -rt1, -rt2, -rt3 -rt4, .... -rt99
>>
>> Or
>>
>> 3.12-rt1,
>> 3.12-rt2,
>> ...
>> 3.12-rt33,
>> ...
>> 3.12-rt111,
>> ...
>> 3.12-rt999
>> ...
>>
>> Now, to have to roll back all my changes, then work -rt patch,
>> then impose SUBLEVEL mainline diff, then last -rt patch, then my =D1=81=
hanges.
>=20
> So we need a different numbering scheme just because your workflow is
> completely backwards?

No, because in positional number systems, an increase in the senior level=
,
junior reset, but not stays the same. Mainline kernel and patches is seni=
or level.



--=20

                                                         Pavel.


--aNStfUbCoKTkdWGJM24I4NvHrmiNwNg2R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCgAGBQJTCnxYAAoJEPtok08Dny2hSWgQAMBoqPOFQW5H1Tq7igSlAP/C
gtjgoQZKCu6Mcr3x/UIFYB3oo5xObP9UufVCE776+clDwMpMosNLtmQCI5DNIub2
Ed4nTezeweYvP508n2msQlAjP9vTX56o6dlb5nYXQbuOcSa4nPEIHzgzJgnZocUi
NRM25czFxUZz8x88IcRjRspECbjN8K04DbyKSGhgHkA66dZ7sG6oxxrW4uA2hGdR
0Y9yFWxZh7ijABcdtxeK2fywDUrKepXvdNt4efzoEiRVDcmDLp1T1NMrK2DjCAvb
kUGN6xDAtJLvDMdf+iT87DDlRM+BVlTlKjOcxFyPduLdBKIToOMuL3I35CjzMiyS
pn6+WKBdKKWjYIPKrrMQYgPuRQUmNpFqJeNIRlVkb3z0be0tftp/86FHaYxd9XWd
/fQzF8P6KHPKLcM6KQ+8ybdhBxDYvPfvbJqNgRsPzM4DBkKgoEXvvCwy4NzfVvAg
8wDzkqQ4G+C8Q5iQ3isjm9FQPBChRb+8oY4VmJPSIgAEFF6bCd/oEZdR8Ho1EXwP
CkVfIciLq3KqTk3n3QrtYGr/AgZQxgPY/+ehCTn7ZCrJJ0OFeryRHj7Inceymaxa
JYHSuS7XMdNLXZoi23UlVPIfb2vguNdFUkVqKIuLjJ5KxoJTYgy15PMSkeO0FYps
mi9cyp/JdcZQvLk1/KLP
=t72N
-----END PGP SIGNATURE-----

--aNStfUbCoKTkdWGJM24I4NvHrmiNwNg2R--
