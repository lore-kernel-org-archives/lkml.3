Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaLARfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:35:43 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58298 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaLARfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:35:41 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH v2] platform: x86: dell-laptop: Add support for keyboard backlight
Date: Mon, 1 Dec 2014 18:35:38 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        libsmbios-devel@lists.us.dell.com, Srinivas_G_Gowda@dell.com,
        Michael_E_Brown@dell.com, Gabriele Mazzotta <gabriele.mzt@gmail.com>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com> <1416754245-15550-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1416754245-15550-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16878661.sfoixWO2OE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412011835.38401@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart16878661.sfoixWO2OE
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 23 November 2014 15:50:45 Pali Roh=C3=A1r wrote:
> This patch adds support for configuring keyboard backlight
> settings on supported Dell laptops. It exports kernel leds
> interface and uses Dell SMBIOS tokens or keyboard class
> interface.
>=20
> With this patch it is possible to set:
> * keyboard backlight level
> * timeout after which will be backlight automatically turned
> off * input activity triggers (keyboard, touchpad, mouse)
> which enable backlight * ambient light settings
>=20
> Settings are exported via sysfs:
> /sys/class/leds/dell::kbd_backlight/
>=20
> Code is based on newly released documentation by Dell in
> libsmbios project.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
> ---
> Changes since v1:
> * returns also -EIO/-ENXIO (with helper function
> dell_smi_error) * simplify code to have less levels of
> indentation
> * style fixes
> * add some comments
> ---
>  drivers/platform/x86/dell-laptop.c | 1023
> +++++++++++++++++++++++++++++++++++- 1 file changed, 1019
> insertions(+), 4 deletions(-)
>=20

Darren, Matthew: can you review this v2 code?

I would like to see keyboard backlight support in 3.19 kernel.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart16878661.sfoixWO2OE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR8puoACgkQi/DJPQPkQ1I/kgCgmwAQWEGR+/Ex32Tqb4n+2GKZ
WnMAmgO1HwoHEEzOwTzyLp+AWoOpXDbm
=ydzw
-----END PGP SIGNATURE-----

--nextPart16878661.sfoixWO2OE--
