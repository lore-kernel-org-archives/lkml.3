Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab3FYVaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:30:46 -0400
Received: from pyr75-3-78-192-68-46.fbxo.proxad.net ([78.192.68.46]:41774 "EHLO
	molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FYVap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:30:45 -0400
Message-ID: <1372195837.8189.42.camel@scapa>
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
From: Yves-Alexis Perez <corsac@debian.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl,
        Henrique de Moraes Holschuh <hmh@debian.org>
Date: Tue, 25 Jun 2013 23:30:37 +0200
In-Reply-To: <20130625211415.GA2899@srcf.ucam.org>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <1371937599.17761.19.camel@scapa> <20130625160848.GA27123@srcf.ucam.org>
	 <1372193037.8189.24.camel@scapa> <20130625205430.GA2438@srcf.ucam.org>
	 <1372194611.8189.31.camel@scapa> <20130625211415.GA2899@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-iYRDbqWaQgPY60HgG8kx"
X-Mailer: Evolution 3.8.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iYRDbqWaQgPY60HgG8kx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar., 2013-06-25 at 22:14 +0100, Matthew Garrett wrote:
> On Tue, Jun 25, 2013 at 11:10:11PM +0200, Yves-Alexis Perez wrote:
> > On mar., 2013-06-25 at 21:54 +0100, Matthew Garrett wrote:
> > > I agree, we should standardise the behaviour. And the only way we can=
=20
> > > standardise the behaviour is to leave it up to userspace.
> > >=20
> > It's pretty clear we disagree on this and that my opinion won't really
> > matter here. But letting userspace handle that just means broken
> > functionality for those who have the chance (apparently) to have an ACP=
I
> > backlight interface.
>=20
> Which, as we've already established, you don't - Lenovo broke it. Your=
=20
> Thinkpad claims to have 100 available levels, and most of them don't=20
> work. The kernel has no way of knowing which levels work and which=20
> don't, so leaving this up to the kernel won't actually fix your system=
=20
> either.

I was referring to =E2=80=9Cstandardize the behaviour by leaving up to
userspace=E2=80=9D. A lot of thinkpads (for example) (all the pre-windows 8
ones) have a perfectly working ACPI backlight interface.

Also, if the kernel has no way of knowing which levels work, I fail to
see how userspace can do better.

I understand that switching to intel_backlight instead of acpi_video0
follows what Windows 8 recommends but for me it looks orthogonal to the
fact ACPI methods now have some awkward (Lenovo) or broken (Dell). I
mean, it's not the first time firmware people break some kernel
behavior. I know it's usually not easy to contact them, but shouldn't
those methods be fixed, instead of somehow blindly switching to graphic
drivers?
--=20
Yves-Alexis

--=-iYRDbqWaQgPY60HgG8kx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAABCAAGBQJRygv9AAoJEG3bU/KmdcClmbkH/3YF65kIl72TTk+5m3EbkYMP
ICKVC4ag5Sb0J/GVzSjo5o2TdDUG3pJUNCeqpsA7z9ummsApzHBuxSNh+IAwF0bK
/2rTagXSB1zM7/TiQDNNg/vA3jZuJQYNS/CKYAQ34CLtigJwU6XDehUU0+DWkglS
2dMAGimCl/OrmCtL2y3C2c+cNdQL4EtdBKU8iA5OGKiUVcJ0uS8FzTdE+UNbh7O7
7V39weyumzFveZHq70hrIzOK/bO+6bOk0qW4oCBhlmAw76l/ZyymaBtxaTVw7i2M
4BHSqCtHsz8WTc5bE/PTPVhkJWXc4+g66LL8W5++RLPpxF01mS04knMconaRAuI=
=8vBi
-----END PGP SIGNATURE-----

--=-iYRDbqWaQgPY60HgG8kx--
