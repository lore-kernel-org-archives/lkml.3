Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab3GQT5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:57:30 -0400
Received: from pyr75-3-78-192-68-46.fbxo.proxad.net ([78.192.68.46]:60519 "EHLO
	molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3GQT52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:57:28 -0400
Message-ID: <1374091038.3844.23.camel@scapa>
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
From: Yves-Alexis Perez <corsac@debian.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-acpi@vger.kernel.org,
        seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rjw@sisk.pl,
        Henrique de Moraes Holschuh <hmh@debian.org>
Date: Wed, 17 Jul 2013 21:57:18 +0200
In-Reply-To: <CAMP44s3uz5fyXKLgS8TFroCVy7Rx-zpXYvX4TGFDX=65ki5T6w@mail.gmail.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <1371937599.17761.19.camel@scapa>
	 <CAMP44s3uz5fyXKLgS8TFroCVy7Rx-zpXYvX4TGFDX=65ki5T6w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-RgWotCFNINvcdOx3X3Ii"
X-Mailer: Evolution 3.8.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RgWotCFNINvcdOx3X3Ii
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mer., 2013-07-17 at 10:51 -0500, Felipe Contreras wrote:
> On Sat, Jun 22, 2013 at 4:46 PM, Yves-Alexis Perez <corsac@debian.org> wr=
ote:
> > Before Linux support for acpi_osi("Windows 2012") (and when booting wit=
h
> > acpi_osi=3D"!Windows 2012"), brightness keys were handled by the kernel
> > just fine, whether in console, in the display manager or in my desktop
> > environment (Xfce). xfce4-power-manager just needs to be told that the
> > brightness keys are already handled and it doesn't need to do anything.
>=20
> How do you tell xfce4-power-manager that?

xfconf-query -c xfce4-power-manager
-p /xfce4-power-manager/change-brightness-on-key-events -s false

You might have to create the key before. See
https://bugzilla.xfce.org/show_bug.cgi?id=3D7541 for more information.

Regards,
--=20
Yves-Alexis

--=-RgWotCFNINvcdOx3X3Ii
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAABCAAGBQJR5vceAAoJEG3bU/KmdcClIx8IAItqi0S7EP1eCnW+S00Mpdv1
xKQC/b23auzglz51SFZ+CDtkRwysS7jB9/3CUBbYuilxYJrCqelsb2MtI+Zv7jaM
2JgO1nF9KT3jlw43EUocZ8aXjhoel6y6DyTk8TLTVphm/IjMiqCZLbxiIXCqd7CR
Wfs0NorlUgjtmuorNQzOuQychvYj9TA96GgcSm/l/rdNpgSEYq/mho+UdmlnJPFy
MM6A1dTzl4HCg+mRurkIyjl1AW80zvjGS07G9Fpfx7vPBFJ3G3pWqzhAoZk2+S7X
Jj5qk9ycocvY0zrjy4Es/WuN/JkOtTq0eoR4BLpbec2KDBKtBqilD32fcOwSRUg=
=dxdM
-----END PGP SIGNATURE-----

--=-RgWotCFNINvcdOx3X3Ii--
