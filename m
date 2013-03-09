Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab3CIIHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 03:07:49 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:45876 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab3CIIHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 03:07:48 -0500
Message-ID: <1362816406.19016.16.camel@scapa>
Subject: Re: [ibm-acpi-devel] x230: unhandled HKEY event 0x6050
From: Yves-Alexis Perez <corsac@debian.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Borislav Petkov <bp@alien8.de>, ibm-acpi-devel@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>
Date: Sat, 09 Mar 2013 09:06:46 +0100
In-Reply-To: <20130307003016.GA21655@khazad-dum.debian.net>
References: <20130304213804.GE22274@pd.tnic>
	 <20130307003016.GA21655@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-srGwRgbnFjx9JKmKB+df"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-srGwRgbnFjx9JKmKB+df
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mer., 2013-03-06 at 21:30 -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 04 Mar 2013, Borislav Petkov wrote:
> > I get this in dmesg with 3.9-rc1:
> >=20
> > [   12.951434] thinkpad_acpi: unhandled HKEY event 0x6050
> > [   12.951438] thinkpad_acpi: please report the conditions when this
> event happened to ibm-acpi-devel@lists.sourceforge.net
> > [   13.516752] thinkpad_acpi: unknown possible thermal alarm or
> keyboard event received
> >=20
> > when pressing Fn+F8/F9, i.e. the display backlight keys. I'm loading
> > thinkpad_acpi with brightness_enable=3D1 and booting the kernel with
> > "acpi_backlight=3Dvendor" so that the backlight intensity gets
> controlled
> > by thinkpad_acpi. But the last maybe shouldn't complain about it,
> no?
>=20
> It shouldn't even work right on a x230, that box should be doing
> standard
> ACPI backlight control...

Also see https://bugzilla.kernel.org/show_bug.cgi?id=3D51231 and
https://patchwork.kernel.org/patch/2124861/

Regards,
--=20
Yves-Alexis

--=-srGwRgbnFjx9JKmKB+df
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABCAAGBQJROu2WAAoJEG3bU/KmdcClTLUIAJN1f4Ydx5DbNVEu2E1dl3GO
oOjyTn2QSrcY8946yFdtkZT/8PKBPPmFvqyS4yT4p7RUS/HHwi6pTXPktNvOaZ0N
sZ+I1hfDCVQBdqCABHUM1inP4V+pP4NR0PSGu0+X53bpdSYHhYUtDTZV8DHg9MCg
vhId8wN4C817ViyAE4EYDzDLh0/5dYioONlLJ7KWtiJdExtZCRyOH1QkurnJQVsg
Iyh3c7hB23luqNBppurS7Pn5SYzUBW9VkxYv9TIQuYkYLCNNMuawD67AKTXlRXt7
4foQiKq7jkCWNXUbQfcvcDFuUMmnMS/C5tFxl6/qkmYCbgunrUcFnrk4F9qYoC8=
=q4hC
-----END PGP SIGNATURE-----

--=-srGwRgbnFjx9JKmKB+df--
