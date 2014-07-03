Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbaGCXd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 19:33:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39278 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaGCXd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 19:33:56 -0400
Date: Thu, 3 Jul 2014 18:33:21 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Paul Walmsley <paul@pwsan.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sathya Prakash M R <sathyap@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND PATCH 1/2] ARM: AM43xx: hwmod: add DSS hwmod data
Message-ID: <20140703233321.GB3655@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com>
 <1402676147-3711-2-git-send-email-balbi@ti.com>
 <20140613162323.GH8319@saruman.home>
 <alpine.DEB.2.02.1406131910060.340@utopia.booyaka.com>
 <20140702032249.GA26010@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <20140702032249.GA26010@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 01, 2014 at 10:22:49PM -0500, Felipe Balbi wrote:
> Hi,
>=20
> On Fri, Jun 13, 2014 at 07:11:58PM +0000, Paul Walmsley wrote:
> > Hi Felipe, Tomi,
> >=20
> > On Fri, 13 Jun 2014, Felipe Balbi wrote:
> >=20
> > > On Fri, Jun 13, 2014 at 11:15:46AM -0500, Felipe Balbi wrote:
> > > > From: Sathya Prakash M R <sathyap@ti.com>
> > > >=20
> > > > Add DSS hwmod data for AM43xx.
> > > >=20
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Acked-by: Rajendra Nayak <rnayak@ti.com>
> > > > Signed-off-by: Sathya Prakash M R <sathyap@ti.com>
> > > > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > ---
> > > >=20
> > > > Note that this patch was originally send on May 9th [1], changes we=
re requested
> > > > and a new version was sent on May 19th [2], then on May 27th [3] To=
mi pinged
> > > > maintainer again and go no response.
> > > >=20
> > > > Without this patch, we cannot get display working on any AM437x dev=
ices.
> > > >=20
> > > > [1] http://marc.info/?l=3Dlinux-arm-kernel&m=3D139963677925227&w=3D2
> > > > [2] http://marc.info/?l=3Dlinux-arm-kernel&m=3D140049799425512&w=3D2
> > > > [3] http://marc.info/?l=3Dlinux-arm-kernel&m=3D140117232826754&w=3D2
> > > >=20
> > > >  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 98 ++++++++++++++++++=
++++++++++++
> > > >  arch/arm/mach-omap2/prcm43xx.h             |  1 +
> > > >  2 files changed, 99 insertions(+)
> >=20
> > Sorry for the delay on this.  Have been corresponding with TI managemen=
t=20
> > to figure out what to do about patches for AM43xx.  I don't have boards=
 or=20
> > public documentation for these devices, so it's impossible for me to=20
>=20
> documentation is now available publicly
>=20
> http://www.ti.com/product/AM4379

at [1] you can find most (all?) board-related documentation. [2] will
give you AM437x GP EVM schematics.

[1] http://processors.wiki.ti.com/index.php/AM437X_EVM_Boards
[2] http://processors.wiki.ti.com/images/9/95/Am437x_gp_evm_3k0006_schemati=
c_rev1_4a.pdf

--=20
balbi

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtehBAAoJEIaOsuA1yqREZQoQAKvLvtUlxjmCttT6C49t1PJg
BXi2mmR7x81OK8pg7m+XnK3hBCX6Rwi74NvWDckc/Du0hOCWpPO/0XlpmMrNvEhf
l2sFn3xKiJPeBjzGRUNcDi98Vt7KSsm4ti2xxJiksbDRvFG0SjsoLYRL/MyTJpz7
W7pZmd1caZzfzaO/AcMKdPIlkPp3TJ7/hg5GpAeZ1sPSEClGK5CXMqGNhhQSmR87
b29e9iSYlOU50n5jIDvEuLWmBdUPIErep5NQn9yCwhl9StsEyP3O2MG4EghdzCVQ
JzqM5r4MoV9OmplYMqxm74TVspzDe4+vKqorQ0B+UZ0mFFFfVqw8jfZvqzKI2SUj
yeP6xhh0DCoovmRWUWHKC4lu1mw/pp6kZR5Bv1CPVA1xdGLQJyKKLm8MS14j0pnK
bMwn7NCaFq3c35BV8zCQUkM80FeZFEN7LQzwbDAOJLfF7ZsB7RowvB7usYxbXF4r
aE6/6qEDzgYLWVpT97ujOPwhDTpn56ALY0LkTwInEPq8LeGgbEWbtXUZgKMAbIRC
XuxNHfkeen2fPyK6q+qWEdRpz9febk0AuEtmyTrVuKa+JgWF2gQWd0BL/A7JdkKw
jXXRt+khhXhnmf7f5UKoaNCI7Yj2R7l7s/Wx1HQag/Pcxm1oZH8nRaI6zG/2qIKi
I+h1DIn6k4+b+rs7HILp
=oJFG
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
