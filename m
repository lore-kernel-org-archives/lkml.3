Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3FYVqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:46:10 -0400
Received: from pyr75-3-78-192-68-46.fbxo.proxad.net ([78.192.68.46]:41831 "EHLO
	molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3FYVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:46:08 -0400
Message-ID: <1372196761.8189.47.camel@scapa>
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
From: Yves-Alexis Perez <corsac@debian.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl,
        Henrique de Moraes Holschuh <hmh@debian.org>
Date: Tue, 25 Jun 2013 23:46:01 +0200
In-Reply-To: <20130625213300.GA3296@srcf.ucam.org>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <1371937599.17761.19.camel@scapa> <20130625160848.GA27123@srcf.ucam.org>
	 <1372193037.8189.24.camel@scapa> <20130625205430.GA2438@srcf.ucam.org>
	 <1372194611.8189.31.camel@scapa> <20130625211415.GA2899@srcf.ucam.org>
	 <1372195837.8189.42.camel@scapa> <20130625213300.GA3296@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-HmBZOgAKIBUw8aNZWuns"
X-Mailer: Evolution 3.8.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HmBZOgAKIBUw8aNZWuns
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar., 2013-06-25 at 22:33 +0100, Matthew Garrett wrote:
> > I was referring to =E2=80=9Cstandardize the behaviour by leaving up to
> > userspace=E2=80=9D. A lot of thinkpads (for example) (all the pre-windo=
ws 8
> > ones) have a perfectly working ACPI backlight interface.
>=20
> And this patchset won't alter their behaviour.

Sorry if I was unclear and if my mail implied that. It was about your
remark later in the thread (and the mail from Daniel Vetter)
>=20
> > Also, if the kernel has no way of knowing which levels work, I fail to
> > see how userspace can do better.
>=20
> It can't. That's why this patchset disables the ACPI interface on=20
> Windows 8 systems.
>=20
> > I understand that switching to intel_backlight instead of acpi_video0
> > follows what Windows 8 recommends but for me it looks orthogonal to the
> > fact ACPI methods now have some awkward (Lenovo) or broken (Dell). I
> > mean, it's not the first time firmware people break some kernel
> > behavior. I know it's usually not easy to contact them, but shouldn't
> > those methods be fixed, instead of somehow blindly switching to graphic
> > drivers?
>=20
> No. The correct answer to all firmware issues is "Are we making the same=
=20
> firmware calls as the version of Windows that this hardware thinks it's=
=20
> running". If Windows 8 doesn't make these calls, we shouldn't make these=
=20
> calls.

But if that introduce regressions, shouldn't workarounds be found then?
Sorry if I keep repeating that but brightness keys handling in-kernel is
quite a useful feature and losing it (because of the =E2=80=9Cbehave exactl=
y
like Windows 8 kernel=E2=80=9D policy) is indeed a regression.
--=20
Yves-Alexis

--=-HmBZOgAKIBUw8aNZWuns
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAABCAAGBQJRyg+ZAAoJEG3bU/KmdcClFHcH/jNv2QPAD8op1cy5dqcGpZW8
KK/ac6JCm94ryOaly5DYyJwRl0+qVAWwMrt+M8eYy7BY+vHMWEtkkjFog+/Nrg6G
plcfiydkUpoqu4RTsg1sfUgbwccQCR4G09k6whdSLRb4lvhgfi1KPzxMWPoBje1Q
KvCQMXL1PY91iSitAn4FGsHGh3TbrhopQXM18GrsnlORFszFNWHYrRSHywfOpBZd
FLF6w7mOSgy0qwnVgbBGac8auJZ2RzmVH8/FboQvmNI11f3l+rlvkx3fDMOKFYWy
+V13SzP293Ma4YgswlQKytOej0xz+9XVuja8chLijCC+pJAZG6wX/aPkcRvFs20=
=g201
-----END PGP SIGNATURE-----

--=-HmBZOgAKIBUw8aNZWuns--
