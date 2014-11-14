Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaKNKZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:25:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33451 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934579AbaKNKZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:25:05 -0500
Date: Fri, 14 Nov 2014 11:22:44 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Benoit Parrot <bparrot@ti.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>
Subject: Re: [RFC Patch] gpio: add GPIO hogging mechanism
Message-ID: <20141114102244.GX20972@lukather>
References: <1413922198-29373-1-git-send-email-bparrot@ti.com>
 <CAAVeFuK4PaFbbYjUsvA-oO78P5qmQvyGqG+Ov4GLghoC=yPAoA@mail.gmail.com>
 <CACRpkdbO20No0A7ttS=kfMx9qE_MZoZzOtPObHefwnNbixpCeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D+UG5SQJKkIYNVx0"
Content-Disposition: inline
In-Reply-To: <CACRpkdbO20No0A7ttS=kfMx9qE_MZoZzOtPObHefwnNbixpCeg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D+UG5SQJKkIYNVx0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 10:19:47AM +0100, Linus Walleij wrote:
> On Wed, Oct 29, 2014 at 8:09 AM, Alexandre Courbot <gnurou@gmail.com> wro=
te:
> > On Wed, Oct 22, 2014 at 5:09 AM, Benoit Parrot <bparrot@ti.com> wrote:
>=20
> > +               line_b: line_b {
> > +                       line_b {
> > +                               gpios =3D <6 0>;
> > +                               output-low;
> > +                               line-name =3D "foo-bar-gpio";
> > +                       };
> > +               };
> >
> (...)
> >
> > I wonder if such usage of child nodes could not interfere with GPIO
> > drivers (existing or to be) that need to use child nodes for other
> > purposes. Right now there is no way to distinguish a hog node from a
> > node that serves another purpose, and that might become a problem in
> > the future.
>=20
> Yes, so I have suggested a hog-something; keyword in there.
>=20
> As long as the children don't have any compatible-strings we can
> decide pretty much how they should be handled internally.
>=20
> Are there custom drivers with child nodes inside the main chip
> today?

o/

Our pinctrl driver is also our GPIO driver, so they both share the
same node.

Our pinctrl definitions are there.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--D+UG5SQJKkIYNVx0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZdf0AAoJEBx+YmzsjxAgh5wP+gN1zLRxrEj3ftOSB5Cx5fVW
7Sl9viBuFOfYVOEcD4bWoP6nkBw2+9dj7sNbEG/HnmcaFz7QhuzJTKGi4qmpeS1n
MW+nMrZ/KE/ZFDT7jdC49F1zg4qUmZ2v3dRjGyVOUFG1al6j+ajhx3S6w5kAFlKb
5EWs4JgeZxaXXJcaurVHAC+6lipq47k1Toqzcwdm0rOKmkYttaoE/LXSGcZyFpvj
L3svmHr27VcsNj73PxErMyLEw41+vXVmSgiy3DU3vYO9HrAvxHq1amPgc9wUN0R8
QffIbbf16cg6ar9qMAqDWa96ijG9NL5AVA3ADOn7O1gf9XHSsCbp8FXyzi6RRT6S
yclt4H7tGxxnLbAhwTNqqKQXeUQNoLnllORSarJp7NGPcWqahVeaRJei0sKSdRzW
AUyiBRBR79beKTABg5UyuPHvzOwW6gCw5jZHOwhDW4OS14MGvLV7fPpvz1wdaHma
orlZXVJRBZYNLGPnM++F6/PPsOHwFQoNe3rE1ZzwHPc4KGbEEi6sQocl6dFNH8hA
6S2tYKUzdQnM+4L9TZjIPlx8uS1pyF4pIKmoUuDIlqE1Zo15cTbzLgd+n+8H8d/t
0OUjC1cAi1D+cTi6MwlWs0jAuPVFCmI6V7dCdzS8M/AYZTr6xLET2ZN+mWVpzec/
mNUEaCOSNPGxXyKNjcj8
=jUSA
-----END PGP SIGNATURE-----

--D+UG5SQJKkIYNVx0--
