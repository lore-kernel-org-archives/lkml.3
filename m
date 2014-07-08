Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaGHIKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:10:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35405 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753186AbaGHIKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:10:05 -0400
Date: Tue, 8 Jul 2014 10:05:35 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Houcheng Lin <houcheng@gmail.com>, Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, sre@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Vikas Sajjan <vikas.sajjan@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3] reset: Add a defer reset object to send board
 specific reset
Message-ID: <20140708080535.GJ13423@lukather>
References: <1403098673-3058-1-git-send-email-houcheng@gmail.com>
 <CACRpkdYfu8HmVCkn9JFh+YP5OPdr8o9nTfoCnkJ7SSpGoenQUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4IYkFBVPN84tP7K"
Content-Disposition: inline
In-Reply-To: <CACRpkdYfu8HmVCkn9JFh+YP5OPdr8o9nTfoCnkJ7SSpGoenQUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4IYkFBVPN84tP7K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 09:52:03AM +0200, Linus Walleij wrote:
> On Wed, Jun 18, 2014 at 3:37 PM, Houcheng Lin <houcheng@gmail.com> wrote:
>=20
> > The Problem
> > -----------
> > The reset signal on a hardware board is send either:
> >     - during machine initialization
> >     - during bus master's initialization
>=20
> I just thought about this a bit, since there isn't already a generic GPIO
> reset driver, just call this drivers/reset/reset-gpio.c and make the
> ability to deferral just a configuration detail of the GPIO reset driver.

Philipp has been working on one for quite some time. See
http://www.spinics.net/lists/arm-kernel/msg321927.html

However, it seems to progress slowly, and we don't seem to be able to
reach a consensus here.

If you ask me, having to set a few extra properties like this just
advocates for a regular reset driver and DT node for the reset GPIO,
but I'm pretty sure Philipp will feel otherwise :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--T4IYkFBVPN84tP7K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTu6ZPAAoJEBx+YmzsjxAgsVEP/jTiyBvmg4EDVfiUjYQ6CJI/
iK+oL952MyOFEfIB+662u22IjLHeQnYwMRTpbPv9IbTh/HDu+q+Z4qTdF+zstu8L
VndbS5gNNU5IGwOLkru4w4jhQ0eCy0ZzOqaE2CkVG1Fa/ogVEi6WJZX2Cfjsu9JA
MVuOMfFJf+gKSPoFl7uMhF4hCwI5cipNwoQ6z/gWHJVfShO+6rm3yoN+qRjIb9kx
+bbZCi2tQcG0vFYNDKRfsWed13oLKs8TvniT0EIepzcEUA7XhfjP33JAU+WR9chI
baWQnr3RMymDQwKg5Ow0w7QQJcmA86R9Q1QdaqTSIFbnuyNCumCgYwmovfOYmL+g
PTzwrGEhaGpD9O6LRiEj36ylkBCyCEg+f23SB2hqWDoajEUVgBD9AOfw3K0V95HN
2v1DvAk6RVjmJSijsewCiJtc0ox3sPpOckWMU5wRxzPcAJkMRCBaeWt/x7VMVsNF
Le2gJ9GDGzjvXott9/SHsWi0z32XyKu2+s6oOAgnTFOj4T4y+YgbQgVAnyLk/saX
y4ivnSswImRPgGT8toGoDpCOZhTgWSu1LtCA+haDoF8iPrFBMqCwoU7RGxTiESV8
nKm2SEd0DVvbTK5Y6ZReXqHn1DFMJbZACRnRmb8KumH0sSfGmRJkZGod5L7wRp5y
CGN+4XQN7Z0tcxh0YLiY
=nk3n
-----END PGP SIGNATURE-----

--T4IYkFBVPN84tP7K--
