Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3FYVKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:10:22 -0400
Received: from pyr75-3-78-192-68-46.fbxo.proxad.net ([78.192.68.46]:41670 "EHLO
	molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3FYVKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:10:19 -0400
X-Greylist: delayed 1572 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2013 17:10:19 EDT
Message-ID: <1372194611.8189.31.camel@scapa>
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
From: Yves-Alexis Perez <corsac@debian.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl,
        Henrique de Moraes Holschuh <hmh@debian.org>
Date: Tue, 25 Jun 2013 23:10:11 +0200
In-Reply-To: <20130625205430.GA2438@srcf.ucam.org>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <1371937599.17761.19.camel@scapa> <20130625160848.GA27123@srcf.ucam.org>
	 <1372193037.8189.24.camel@scapa> <20130625205430.GA2438@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-UaGPv2ffmJnVd9Pb+rb8"
X-Mailer: Evolution 3.8.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UaGPv2ffmJnVd9Pb+rb8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar., 2013-06-25 at 21:54 +0100, Matthew Garrett wrote:
> On Tue, Jun 25, 2013 at 10:43:57PM +0200, Yves-Alexis Perez wrote:
> > On mar., 2013-06-25 at 17:08 +0100, Matthew Garrett wrote:
> > > Right, the kernel has special-casing to hook the backlight keys up to=
=20
> > > the ACPI backlight control. This is an awful thing, because there's n=
o=20
> > > way to detect this case other than parsing a single driver-specific=
=20
> > > module parameter.
> >=20
> > I'm not sure what that means. To detect what case exactly? That the
> > brightness is handled by video.ko?
>=20
> That the kernel will automatically handle backlight key presses.

Ok, so for detection by userspace? hal managed to do that just fine, it
seems that upower doesn't, for some reason.

> The behaviour is already inconsistent. If you have an ACPI backlight=20
> interface, hitting the keys makes your brightness change without any=20
> userspace help. If you don't, it doesn't.

At least on the same (class of) hardware it always behaves the same.
>=20
> > And in the end, the user just want the brightness keys to correctly
> > handle the brightness, full stop. Having multiple brightness daemons
> > using different policies on different hardware is a nightmare for the
> > end user, imho. From a user point of view, having it handled all in the
> > kernel works really pretty fine and is completely transparent (I have t=
o
> > admit that from that point of view, it was even better when it was
> > handled by the EC but those times seem long gone).
>=20
> I agree, we should standardise the behaviour. And the only way we can=20
> standardise the behaviour is to leave it up to userspace.
>=20
It's pretty clear we disagree on this and that my opinion won't really
matter here. But letting userspace handle that just means broken
functionality for those who have the chance (apparently) to have an ACPI
backlight interface.

Regards,
--=20
Yves-Alexis

--=-UaGPv2ffmJnVd9Pb+rb8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAABCAAGBQJRygczAAoJEG3bU/KmdcClaLIH/1jamYk4eOPNcVll/621eWom
1WhujXtkRA1SQTHOtu//CW7PIIkoE5ry6cd5Wy6C5Aq5vVshXgZoJ5tdQ101SXYP
c7sI1r5vrVy39T197r4CWz10syK9Zf4yo+4QAN6aI+C+uBxdHYOqf4f+gUPriCbN
SezoragsNCAb1Y7NLHJDnA1o0Vp9Pdp7nrnRnG14cg+fEKc88hjz2dD2kI1hESqv
RR43tnbziPYB7P1BjRao0/S5QXtPubSqijbiahw6G+HhTYWIfYFzUnuO9rEIQQIh
XehCuryZT4BIZCtzLPoHC5dXZE6gCQH8vfNc4kmJ/Amytm9v0H97s9TmWDJ7Myc=
=mPcq
-----END PGP SIGNATURE-----

--=-UaGPv2ffmJnVd9Pb+rb8--
