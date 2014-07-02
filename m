Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaGBDXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 23:23:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53995 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbaGBDXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 23:23:18 -0400
Date: Tue, 1 Jul 2014 22:22:49 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: Felipe Balbi <balbi@ti.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sathya Prakash M R <sathyap@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND PATCH 1/2] ARM: AM43xx: hwmod: add DSS hwmod data
Message-ID: <20140702032249.GA26010@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com>
 <1402676147-3711-2-git-send-email-balbi@ti.com>
 <20140613162323.GH8319@saruman.home>
 <alpine.DEB.2.02.1406131910060.340@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406131910060.340@utopia.booyaka.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 13, 2014 at 07:11:58PM +0000, Paul Walmsley wrote:
> Hi Felipe, Tomi,
>=20
> On Fri, 13 Jun 2014, Felipe Balbi wrote:
>=20
> > On Fri, Jun 13, 2014 at 11:15:46AM -0500, Felipe Balbi wrote:
> > > From: Sathya Prakash M R <sathyap@ti.com>
> > >=20
> > > Add DSS hwmod data for AM43xx.
> > >=20
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Acked-by: Rajendra Nayak <rnayak@ti.com>
> > > Signed-off-by: Sathya Prakash M R <sathyap@ti.com>
> > > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > ---
> > >=20
> > > Note that this patch was originally send on May 9th [1], changes were=
 requested
> > > and a new version was sent on May 19th [2], then on May 27th [3] Tomi=
 pinged
> > > maintainer again and go no response.
> > >=20
> > > Without this patch, we cannot get display working on any AM437x devic=
es.
> > >=20
> > > [1] http://marc.info/?l=3Dlinux-arm-kernel&m=3D139963677925227&w=3D2
> > > [2] http://marc.info/?l=3Dlinux-arm-kernel&m=3D140049799425512&w=3D2
> > > [3] http://marc.info/?l=3Dlinux-arm-kernel&m=3D140117232826754&w=3D2
> > >=20
> > >  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 98 ++++++++++++++++++++=
++++++++++
> > >  arch/arm/mach-omap2/prcm43xx.h             |  1 +
> > >  2 files changed, 99 insertions(+)
>=20
> Sorry for the delay on this.  Have been corresponding with TI management=
=20
> to figure out what to do about patches for AM43xx.  I don't have boards o=
r=20
> public documentation for these devices, so it's impossible for me to=20

documentation is now available publicly

http://www.ti.com/product/AM4379

--=20
balbi

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTs3sJAAoJEIaOsuA1yqRErJkP/0IUeyJWfszabOTT5qEemT4r
WoZLGpEPgkdttLrFFg6XSFwFTXYWPLGchPTnqS1l521n9nYpWS+duf5Z9rkyq7VZ
J+UdysY0k1RfwNpDg1gfbDMBKO9PIXBNfaK5FRfGpW+r7WA7W36/jIi+4YH8qdMA
yO24nxXoP/OtJH8QrTnzjZ8Z7L7cv5krdmMXUqS/AlYpLZyKXRgZMWZFFfq4anpr
Wqqis2jSRa7p7Lr0wrB+lCDiV6gzxqwQ/7nO0uAD/VuwG0CoxlGWb7thjr8yYODv
Lu+ieq/E8P3/q/IITPO0/IzcUmt89DSHbzur+ZCIfoenHfMeb2sB9X9K1frUZOhJ
LNUmBmQAADw6QwGCSz/Op4qnD4qNtgvneUfDbySSVQAnf5ihLg+AXuBNCfp/GeCv
AwjYwNvVgUuV2mqP9iOVoHReDzmZJMXVqn5jUiZMYIvqu43Ka2LXZb1CvUhjU8Fr
sBadYqmppfIvJdQ3nXIOy/YXVBW1ewEBbwvaSDY8koeSG00Cq4LeimIzwa9A/Qf5
yE5gXonA/ATZUO4nSD3XVTJFEm6KB2qWggd/liLCOzFv1RvS+v0BFz2R46W4Xf2Z
5iYlmcPzX/YB8bVXudr4+636Kke04ejQo1c0FetTZ50ennc0H6Tv+ZMBUZr2cB4c
L47l6y44dpynS3x8vVyW
=qBjV
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
