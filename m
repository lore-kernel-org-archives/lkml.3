Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbaLHOfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:35:16 -0500
Received: from down.free-electrons.com ([37.187.137.238]:37685 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751709AbaLHOfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:35:14 -0500
Date: Mon, 8 Dec 2014 15:31:25 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v5 00/61] dmaengine: Implement generic slave capabilities
 retrieval
Message-ID: <20141208143125.GD8739@lukather>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141208061746.GD16827@intel.com>
 <20141208093246.GB27228@ldesroches-Latitude-E6320>
 <20141208133047.GM16827@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cHMo6Wbp1wrKhbfi"
Content-Disposition: inline
In-Reply-To: <20141208133047.GM16827@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2014 at 07:00:47PM +0530, Vinod Koul wrote:
> On Mon, Dec 08, 2014 at 10:32:47AM +0100, Ludovic Desroches wrote:
> > On Mon, Dec 08, 2014 at 11:47:46AM +0530, Vinod Koul wrote:
> > > On Mon, Nov 17, 2014 at 02:41:54PM +0100, Maxime Ripard wrote:
> > > > Hi,
> > > >=20
> > > > As we discussed a couple of weeks ago, this is the third attempt at
> > > > creating a generic behaviour for slave capabilities retrieval so th=
at
> > > > generic layers using dmaengine can actually rely on that.
> > > >=20
> > > > That has been done mostly through two steps: by moving out the
> > > > sub-commands of the device_control callback, so that the dmaengine
> > > > core can then infer from that wether a sub-command is implemented, =
and
> > > > then by moving the slave properties, such as the supported buswidth,
> > > > to the structure dma_device itself.
> > >=20
> > > Okay managed to get this done. Apart from the two issues identified d=
idn't
> > > find anything so applied and pushed to a branch
> > > "topic/slave_caps_device_control_fix"
> > >=20
> > > Today did some compile tests and found few warnings, were trivial but=
 I
> > > am worried about the testing of this code. Has anyone tested this, if=
 so
> > > which platforms are covered Since I pushed base branch last night, Fe=
ng's
> > > bot covered it and all was OK. Looks like Feng's bot doesn't have wide
> > > coverage of arm platforms, wasn't there one run by arm guys which tri=
es to
> > > test and boot, if so can we get this tested there please.
> >=20
> > Tested with your branch on sama5d3 and sama5d4 so at_hdmac and at xdmac.
> >=20
> > I have also sent some patches based on Maxime's series for at_xdmac.

I did the development on the Allwinner A31 (sun6i driver). So that's
tested too.

Thanks to Ludovic for his testing.

> Anymore voluteers? I am looking at omap, mxs, tegra ones (these had
> issues)

Since these were compile time issues (and trivial one). From a
functional point of view, beside the warning introduced, this won't
change anything.

And even if it does, we have a full bug-fixing window to take care of
that.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--cHMo6Wbp1wrKhbfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUhbY9AAoJEBx+YmzsjxAgsb4P/2ZuSK4hc5MXQS3bKF1sALCS
HI0ExYYBTcCpEi4EDJDSvbzDw0vYVjvO0MlgfKqe7DRnLYjWYqM+UamMIpPUROzv
EsVOAJpVtRAG7axRlZgMIHLq7RUUwayiTzU7z/Ki3wN7YLuFu48BAhJrD+1iYt/I
wQdmo9EEB3aP4ih1s1XiQ/vHWfP9OW5I6+R9ccuyAcMhf9/MuKclAXuIuKiRbzNX
4z4DKyWWH873P9RY8DVU/Xs/YWxwFQ3CF7JWnaKbitglZgyO+rEeL+cr04ZnuPup
oi4LzIejHUH83k4GsaH0zcpsLHHuwvaF9MAoaO7CIq5glap33P+SZPDTLF//MPkJ
AEE3i8rzc+v/WGPzghbVxK8ecSRmvo18QDh63qZLROQQTkrXa80SQ9/8WeVpg6nf
dT01i2whbqlyOC1bT8wk8QjWRY90Jst2qwzbNk4RR4MrPOb2Yj3Sd3IoBZ5yK12+
3TiC6wO2qIwC3/ENp/PJRan0HE4rgSXcSbCRa+nMzg160jC8bIyFbK5L1fGSxEy3
tcyJiOUm+uZ58PgzeiqWNhiGPdQIhZ/YsUPnO+sqvulZa0witnDcvcHPPpvZ7+2N
aY0JEY64+YM4VP0uzIv5vEVk0fZp23vVywI9KFN/B2UfzmiaZ+dvnzy16zsv/N/K
Z71oV18/ESxHJavfhLu+
=1mxv
-----END PGP SIGNATURE-----

--cHMo6Wbp1wrKhbfi--
