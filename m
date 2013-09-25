Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3IYUHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:07:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39893 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102Ab3IYUHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:07:33 -0400
Date: Wed, 25 Sep 2013 23:07:32 +0300
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/26] ARM: sunxi: remove custom .init_time hook
Message-ID: <20130925200731.GM2954@lukather>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1379526839-14798-24-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mPOSj6iWmtyhwOMz"
Content-Disposition: inline
In-Reply-To: <1379526839-14798-24-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mPOSj6iWmtyhwOMz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2013 at 07:53:56PM +0200, Sebastian Hesselbarth wrote:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove custom .init_time hooks.
>=20
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

How do you want us to merge this? Every maintainer takes the patches he
handles, or will Kevin and Olof merge the whole thing?

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--mPOSj6iWmtyhwOMz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQ0KDAAoJEBx+YmzsjxAg1GUQALSsQ4nvgiv6G1zlZxPR5RRM
qy21pc8IKn+ehwh7uTTzmHiAEHwY7961na8y+XuMl+kKDf2drCleGYa0BQQXjlmW
0oSDo72gYW4itfMqQ2cdRYlJ/Yk0AZAsQNT3z72K80XVIP4jaWMI9kWKHxyMrX0s
ksHvTAz7x+soD+6XP0cwaVFT7v2GzZcVsKOJRry2LuBRd5F/60r16VqqxFFgOwWW
WkT5Bjk0Teq5u6BO8jyhZiWC6hIcldkev9M4c5svAyOiDCRBhY/0AO6z/a8j5G6U
1cvsHA4B2eM2QcxIwcDVgGy55IjjARYJ6QZrNdw2at1zWlct4iV0s4f4Ej/5D4D7
ko2sCpt06d4H1+lpDVKA2L8HwbA/s3hgGfI5yv2Ex1u/RJ7XWrpqRy4PF9Tr6bFI
9la4GauRgj8W0mrOaKgKb0oe7DcIFUUVFh/swc9bgC9I/F7V3izS405GDS7xobnS
O2H30j9QUAmbCbHns2GQ6bNm5X/P8gO30P7vhKxmfspF2vGDf7PKD4ja5XWgYxr6
tSOVgjBtJFfxWUfg2vInv21cHMG14L3Tk4JXAfUh85Lu2cxF65MxO/pbN8erC3DW
n1e1hcECSjnhokNE8Lq0DMVRbghStjI7bUy2kVjvWqOgBqcrYobLKJVRRLcuRXCq
0/c5/A04qjnu4qLbK1j0
=kYDY
-----END PGP SIGNATURE-----

--mPOSj6iWmtyhwOMz--
