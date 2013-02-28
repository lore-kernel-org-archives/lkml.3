Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768Ab3B1Vbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:31:40 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:43864 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3B1Vbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:31:38 -0500
Message-ID: <512FCCBA.7000404@gentoo.org>
Date: Thu, 28 Feb 2013 22:31:38 +0100
From: justin <jlec@gentoo.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Use config scripts to detect ncurses libs for menuconfig
References: <jlec@gentoo.org> <201302271937.49565.yann.morin.1998@free.fr> <512F24CC.2090906@gentoo.org> <201302281908.14787.yann.morin.1998@free.fr>
In-Reply-To: <201302281908.14787.yann.morin.1998@free.fr>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2TNUJCPXCNTRRPOKGUBGG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2TNUJCPXCNTRRPOKGUBGG
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2/28/13 7:08 PM, Yann E. MORIN wrote:
>=20
> Well, RHEL4 is still widely used, and it was released in 2005, so will
> not have ncurses-5.6 (updates may have it, but not everybody installs
> updates).
>=20

Hi,

question, will such system be updated then to latest kernel sources? And
if so, can't we require that for the ncurses based config menus need
newer ncurses?

Justin


------enig2TNUJCPXCNTRRPOKGUBGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlEvzLsACgkQgAnW8HDreRbYKACfXRPVU6Ld9VGKmIcrMYOLroMJ
sTkAn0ktq6kmUd3HwAK9mNPSye+1GPnw
=VBdL
-----END PGP SIGNATURE-----

------enig2TNUJCPXCNTRRPOKGUBGG--
