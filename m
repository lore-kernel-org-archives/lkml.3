Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaHFL3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:29:15 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792AbaHFL3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:29:13 -0400
Message-ID: <53E21186.3000702@nod.at>
Date: Wed, 06 Aug 2014 13:29:10 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [GIT PULL] Global signal cleanup
References: <53E20F1E.2080606@nod.at> <20140806212720.66dbd58b@canb.auug.org.au>
In-Reply-To: <20140806212720.66dbd58b@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="r33u7PHmOnJtjCj8t01NFpF8ODcCjg63U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r33u7PHmOnJtjCj8t01NFpF8ODcCjg63U
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 06.08.2014 13:27, schrieb Stephen Rothwell:
> Hi,
>=20
> On Wed, 06 Aug 2014 13:18:54 +0200 Richard Weinberger <richard@nod.at> =
wrote:
>>
>> the following changes since commit 19583ca584d6f574384e17fe7613dfaeadc=
dc4a6:
>>
>>   Linux 3.16 (2014-08-03 15:25:02 -0700)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal-cle=
anup
>=20
> This has all been rebased onto v3.16 but none of the patches changed.

This was my indention. Also I've added some acks.
Did I screw something up?

Thanks,
//richard


--r33u7PHmOnJtjCj8t01NFpF8ODcCjg63U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJT4hGGAAoJEPmeIjfg4UaayLsP/1rteWCjezmHqCvrZq8LH5Ba
n448/g8fQIUTpPwFMKKo13GrBnNmz90f7VM9ulIyhi6/YnMjjP2rMfCzRC7QyDLR
ktbyuGT+12CNgfFJYks0Pu36gAtmejIksNpfBz1pJQWN6MQWbm8KnQ6XzkSnxx3q
XKFQZlDT56v96orwCzi0XLlSXVKp3W7zgyxJr+lR6BMdPSbH3q47hL12w+l2QLRA
rXevPgf+054OW7EqkWzERJYyuazBQ11dTbLKg7A4XfwocNaQFDTFHN0TWoWLjQMJ
1Jx5eNz/fYKB9X++u6AKipHxUxKLr/SMinNWTxZHAy7c0wv07+8xvcUDe7Mu/2pr
cZVbzKAcju5gLv2zk/95GVknZhuV9QbArdzKoadz3jgf3kHmwXWQfRoXkcWLzUFS
SX1f6aYCHYKFBDbfZCe7NjyivATQw9ao265QHqUoGw7BMY0fZNwj2HseMI/mIACG
RK/enOZvZJfmbIwMi7Mbay0rxgslEvx1pHdseZIn3JF/hhz9pW+S6H1K3kVoVLzn
gjP1sIGBnHC2KiyjrpDQaAWBr3Z3Lceuk9hF8HSFKgt7W2c6x7+aF2acLYm7EkCQ
z9vl5SAVxThEuRjMqF52og9KUCW8o41SuILnEk1zmTcbFC/yQChiMeNCH0Wr7g1R
zXYM9fKJBiVOM7Mq/Pmv
=tOQr
-----END PGP SIGNATURE-----

--r33u7PHmOnJtjCj8t01NFpF8ODcCjg63U--
