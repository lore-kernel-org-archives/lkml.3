Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692Ab3B1ViD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:38:03 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:44291 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab3B1ViA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:38:00 -0500
Message-ID: <512FCE40.4040101@gentoo.org>
Date: Thu, 28 Feb 2013 22:38:08 +0100
From: justin <jlec@gentoo.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Use config scripts to detect ncurses libs for menuconfig
References: <jlec@gentoo.org> <201302281908.14787.yann.morin.1998@free.fr> <512FCCBA.7000404@gentoo.org> <201302282235.28016.yann.morin.1998@free.fr>
In-Reply-To: <201302282235.28016.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2EVIKPQAEEGNJLMQVIXLR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2EVIKPQAEEGNJLMQVIXLR
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2/28/13 10:35 PM, Yann E. MORIN wrote:
> It's not that those systems will be updated to run the latest kernel, b=
ut
> rather that those systems can be used to build a newer kernel for anoth=
er
> system (think eg. cross-compilation and embedded).
>=20

That's true, I will split the patches as suggested.

Jusitn



------enig2EVIKPQAEEGNJLMQVIXLR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlEvzkAACgkQgAnW8HDreRbS6gCfZkss7EUHQ1AYFcTCfdHxjLxn
PzEAoL4ziuKXlCiIJA18MmrEQVpcAtlz
=95Dj
-----END PGP SIGNATURE-----

------enig2EVIKPQAEEGNJLMQVIXLR--
