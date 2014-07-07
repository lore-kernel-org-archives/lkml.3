Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaGGMpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:45:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56427 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753157AbaGGMpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:45:04 -0400
Date: Mon, 7 Jul 2014 14:41:57 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "andriy.shevchenko@intel.com" <andriy.shevchenko@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhuzhenhua@allwinnertech.com" <zhuzhenhua@allwinnertech.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 2/2] dmaengine: sun6i: Add driver for the Allwinner
 A31 DMA controller
Message-ID: <20140707124157.GA13423@lukather>
References: <1404134454-25513-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140701124852.GB6064@leverpostej>
 <20140704075710.GN31996@lukather>
 <201407061722.01279.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <201407061722.01279.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 06, 2014 at 05:22:00PM +0200, Arnd Bergmann wrote:
> On Friday 04 July 2014, Maxime Ripard wrote:
> > > > > It feels a little fragile to rely on the organisation of the cloc=
k tree
> > > > > and the naming thereof. If the IP block is ever reused on an SoC =
with a
> > > > > different clock tree layout then we have to handle things differe=
ntly.
> > > >=20
> > > > What do you suggest then?
> > >=20
> > > I will admit that I don't have a better suggestion.
> > >=20
> > > Without knowing which particular constraint on the mux parent clock we
> > > care about it's difficult to suggest anything useful.
> >=20
> > Well, I first made it into the mach- directory, and then was told to
> > move it in the driver itself, so we're kind of running out of options
> > :)
>=20
> How about having a property in the clock provider node that forces a
> specific value for the mux? I think that's generally the preferred soluti=
on
> for any clock settings that go beyond what an OS can be expected to figure
> out for itself.

Except that we don't really care about the parenting if the device
isn't going to be used, so putting this property on the clock provider
doesn't look that good. Plus, in the case where we have multiple
clocks defined in a single node, it wouldn't work that great.

However, I'm not convinced that it should be on the device node
either, because we could end up having conflicts between devices.

I don't know, some C code seems like the easier and more flexible
solution here.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTupWVAAoJEBx+YmzsjxAgBL8P/icWVgxZkRDqSMyd4dFTQHtq
DDkLB2z4cykWaFOKLNsYdbCkixQuJuZmesGMsPXNDLjxsAHQCOgRM4IUKQo9AvVH
d91KBr4O/lYL1fQY3PHRyYi23dV8a5BLjc4dyWx4OG09SvKSpADdUZK/XvhqClUu
JY8kUd28lrjDYvS1fwns3//jnGrmPfQ0kWSYhCCVHraVYVUxqj6RMUWP9vhaVsa8
2u4x4stD5oKDby9wKCqEl8hy8IsEBY978bR5nsg0ldwHgSNGm0LZyw1VRLJEbUvH
6POGRXKk03nZXvacVsM0ctAEZi0aNcFEWSuO/Jul0Q25i+mON22jbDvaiYI64Uua
D5GAQ5dOGIPW58+1ZgDgUy1AqwP1ah0nq7OLAZkQaTPMok2KVX3+71dEJBQQSA5J
v0MREIY0tf/+I9airElB0m4e4Q0F0FMVpHjauokRg9Zws9FfHFzlx5U/hw6wK1Xb
4O6HGq2PMnXKAgNcuIYHkTfpfIBh+CgW+8WbtV2bP85RwmJAAM2CZIfBXegrpLnF
1diNQtWBkX25ma2Ga6Q5f0qu4LjEXH+EOqs7NLuFStm6x5sO5mfwOjxlMFuy1rIQ
4aYCwAW2zqlYX/EikIISQwP7ad5ypOHShTv9Pkudx6jItoFUwC12dAY9XXRC4Ciu
CL0ydXg3yxNNYD8PXMX2
=qsS5
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
