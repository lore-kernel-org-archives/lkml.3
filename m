Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3FRJqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:46:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38562 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab3FRJqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:46:49 -0400
Date: Tue, 18 Jun 2013 12:44:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 5/9] ARM: OMAP: USB: Add phy binding information
Message-ID: <20130618094438.GT5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-6-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qUsYCxAE223BCwdt"
Content-Disposition: inline
In-Reply-To: <1371113039-5784-6-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qUsYCxAE223BCwdt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2013 at 02:13:55PM +0530, Kishon Vijay Abraham I wrote:
> In order for controllers to get PHY in case of non dt boot, the phy
> binding information (phy device name) should be added in the platform
> data of the controller.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

I would rather not pass strings around, any other way to handle this ?
Why do you need to pass this string ?

--=20
balbi

--qUsYCxAE223BCwdt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwCwGAAoJEIaOsuA1yqREea0P/3uBLjXFopxteuCcAx2qZTmf
T+l5gevfoAR8r9zX8pUL5ReymsSLouHiimJU8742y+K+cYmMOaOXDtOjh/JGXWXy
MdWFO4LJ3AnIgHdtZ1L8eafxHnhM8PWwuQaUUfP5nBStfRPf1jJ8hTKdDvQQ7ZS0
KUHNVCZNeaB2Y/JGVjPeeXFhSY9DPAnBTBCtXL7b4uKh3LTIt3/P8rCT1EW+C2Mu
BcJ3cDLxhGUtrjg+GSb9080cbl08M5t4gOdm3PN35T01vDjqcuO5XhKkGdsMUGig
XgbLXn9rW4pVgndp678CKkLaAuXf/JI57kTBJ8Fv50LL8xZGDj19M38mF0oVeUzT
XW/2DpzS3Ukx5s5SEMveyFjbUk2sPQBdHEI0355LyOX3nI1t43LCBt8sRs8y7Qrg
7dmCCThlhyHotVPl2/UUQYF8Kq0ERGnOmN6uDUn4JW4iwdJVKeQ8/R97f4H9Jny9
PQ7MEqN5CZ5foIOTJ2fiWYUOeCvWmWLTwSHxyUyFVj37m/addqnFYdYLvSF6vc4L
ETbZoQ5eMzublhqaGqsYoIQSgXwjIyrXZ4+2lGrdCHLpPIDWT6t/9CS//IFquWqO
8CMzMVtdh+PXDgjVeq0N46w43grY/dj+pKVXp/UjvfBL9pDiKkkx0pN6vzfm7/xR
MbU+cLw2DucuQK1PmPs3
=yi3T
-----END PGP SIGNATURE-----

--qUsYCxAE223BCwdt--
