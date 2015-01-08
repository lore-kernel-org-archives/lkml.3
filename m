Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbbAHJAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:00:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55555 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbbAHJAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:00:30 -0500
Message-ID: <54AE3F9E.7060904@pengutronix.de>
Date: Thu, 08 Jan 2015 09:28:14 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: "Wu, Aaron" <Aaron.Wu@analog.com>,
        "adi-buildroot-devel@lists.sourceforge.net" 
	<adi-buildroot-devel@lists.sourceforge.net>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bfin_can: rewrite the blackfin CAN driver into arch independent
 style
References: <1419391828-21105-1-git-send-email-Aaron.wu@analog.com> <54AD4461.1040203@pengutronix.de> <649EF91064D35D40B9C93A225BF41674612E3EDD@NWD2MBX7.ad.analog.com>
In-Reply-To: <649EF91064D35D40B9C93A225BF41674612E3EDD@NWD2MBX7.ad.analog.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="apjeow0XCp8tobw713n1b7bLr0Tv5PnUm"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--apjeow0XCp8tobw713n1b7bLr0Tv5PnUm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/08/2015 08:13 AM, Wu, Aaron wrote:
> Thanks for your comments. I've split it into two parts and submit patch=
es of V2.

Thanks!

> Do you mind if I fix potential bugs with future patches?=20

Patches, especially bug fixes are always welcome.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--apjeow0XCp8tobw713n1b7bLr0Tv5PnUm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrj+eAAoJECte4hHFiupUKTEP/0CuZ0sWcX9NYspB1ZL/plDr
ktujAZq1+eQqNSDYG34wi36e8MszsWnp83itzU1Y6zpVEgsqM2Q2dk+ncC6SrOBS
W1vIa2LMzXWsrFIpbS2wa9M8Qfpy9WUDdpvEPn6RG4i4oaMD6rO7bb1YIoC8Z/Qb
C3k2o3C6b7jw/HaE3QtJeEkQNY/F25iS7yu323xJNpKkYAezPYHYYX8lnCF77Yld
O7nTcO/KiJjO9woUL5CJg1hKPD4/gKIr4z+DkOtN8VHkmsLALhjfidSm1D8PTfmh
pdV+gXVrtS7nt5ZuEjmBeJr/WkC48y/5/x1s9cZNrqHjX7NzMMVgEkiK/ou9hSXs
InQowaQnPRr1EXUxWoUSw7N5MeVP48Z4SWTBsU60HsscqsaKMi7fkR7M4Q7ei//F
L57qXXimmAKOn5gpEJ+Xr32Je2wU+dn1Vd0GKzJE0/iLBAUF2dIOwdTTo5Vax1bI
K2P+Md3JWulmFrknqMHP59TglueUSE9QMoG0lTTQ82CEy70Mz64yxXjKbZMidWWo
U5Vs/HEyYSDduUn/xnodm8TeeWKKDi6PdxXpEAb8/hQJjY2JfFNCWYzc1mddpgNB
ppVQD87Sk0dvU5DNW52o+qoRVhvoC/avR/03tXeuKZbrT7aGdauh+89/juIKf86q
wsEzxfNFhgkSbC4Kc5LF
=RCtF
-----END PGP SIGNATURE-----

--apjeow0XCp8tobw713n1b7bLr0Tv5PnUm--
