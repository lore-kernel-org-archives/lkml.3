Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3F0RjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:39:17 -0400
Received: from rrcs-24-173-105-85.sw.biz.rr.com ([24.173.105.85]:44258 "EHLO
	mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab3F0RjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:39:13 -0400
Message-ID: <51CC78C2.2020406@gentoo.org>
Date: Thu, 27 Jun 2013 12:39:14 -0500
From: Matthew Thode <prometheanfire@gentoo.org>
Reply-To: prometheanfire@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130520 Thunderbird/17.0.6
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        kernel@gentoo.org, hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed), when
 booting with mem=300M
References: <51CC6CAE.6070401@gentoo.org> <20130627172705.GA16316@srcf.ucam.org>
In-Reply-To: <20130627172705.GA16316@srcf.ucam.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2JWPGSDDRJICHWNKWUHDP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2JWPGSDDRJICHWNKWUHDP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/27/2013 12:27 PM, Matthew Garrett wrote:
> On Thu, Jun 27, 2013 at 11:47:42AM -0500, Matthew Thode wrote:
>> There is an early boot failure with linux-3.[9,10].??? when booting
>> using uefi on low memory systems.
>=20
> Does it happen on systems that genuinely have small amounts of memory, =

> or only on systems where you're passing mem=3D?
>=20
I don't have a system (or even memory to place in this one) that has
that small amount of memory.  Do they even make ddr3 sodimms that small?

--=20
-- Matthew Thode (prometheanfire)


------enig2JWPGSDDRJICHWNKWUHDP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRzHjZAAoJECRx6z5ArFrDXtkQAInHEykCC2pM6nITTLUxaJbA
nYg7x3g8hHEecZappYZtA4Aa+G3kR+900LLMe2tKpuhZm/yShd2zzdHCwbg5+7p7
5LzlJuGVJLTfrhnEgPmLPxONjAYdkHMHFA9/vJ3VjLcbNgtr3Nfh5VkmIe9LEkVP
RiGIMl66/IvAbBwkfX9cEb8m1iX5hMjZYaN7uWRmUiwHQPnmScoECri74ohKZY3A
LCaz7QY88CVTUUegMzWbn+Mo2+lwOjSBvnsu7RDNEtOjzVfZb4c1O/rjPYmS7jtj
smB3a4DAR3NrlFi81N9N07/+Zz3Gx3Uty6koQBRrMQBd8necVVu+pXXtHYS99a2L
sjl2OGok+xzofs/DYd3rwrg8lYE4XT/7SKCdkmBsfBqLbnyqSG0i4g/G7Hqz7Vrf
0Ac1sjL0xokYsG8QerOb5xzyNFHmi60QJLR3cLtkiaPBiDtWlLNvF8pkbxKZbpk1
ZM10ZKGYpzTqrHfG8iMNgoZrsV/bO21aMbkK++vW/AHWxykiqO2f2oxNXZeh8Hnm
vHKH1ClmF+LKaDpQP8mkMSkOHHViuS/Zv4RkDts3sQg2Dy+pa0E9AnRivagugegd
dh63stNdBJbKMHMlTt7K+c3T9VoQ5Q37AwSHgjsjn98PJ/jcDM9i48K0kYM9qaFE
awM/2WEG2Snocdf42ceZ
=s65X
-----END PGP SIGNATURE-----

------enig2JWPGSDDRJICHWNKWUHDP--
