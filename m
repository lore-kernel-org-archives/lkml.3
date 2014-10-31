Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaJaQpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:45:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59426 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaJaQpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:45:11 -0400
Date: Fri, 31 Oct 2014 16:44:18 +0000
From: Mark Brown <broonie@kernel.org>
To: gyungoh@gmail.com
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141031164418.GC18557@sirena.org.uk>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-8-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aoTbOZUmF9JI49gR"
Content-Disposition: inline
In-Reply-To: <1414739322-12487-8-git-send-email-jack.yoo@skyworksinc.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v6 7/8] regulator: sky81452: Add compatible
 string for device binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aoTbOZUmF9JI49gR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2014 at 04:08:41PM +0900, gyungoh@gmail.com wrote:
> From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
>=20
> Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>

This doesn't apply against current code and depends on the MFD symbol
rename - can you please check what's going on here?

It would make sense to split the Kconfig symbol rename into a separate
patch to ease merging, it doesn't seem obviously related to the driver
change and should probably be in the same patch as the MFD symbol rename
for bisetion.

--aoTbOZUmF9JI49gR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUU7xhAAoJECTWi3JdVIfQey8H/3Y7D4bgU+PfhoOc9N+hRzgz
9Z9jKyevGFTBp/79i5QZGfUIAsylcp+Pu8hrlIQCMcn1L3lvHggB0fXYqnxowIQK
SCveryid4DiA6A1FmJuLuQZyte8gyhkJYP/Z4MKd/LNIeEz989EmdyVOHzoHmxx3
Xg/DK2YZFkII7jFgkmrPtMGzb9umkiyoKB1Y97K2MW3kYtWN6fsKdbe8c2ESxsvz
hZmeULqZztOdBujRjPpymDKSuNzG4lC2zW0xoGrFSEhZOl5wXo3qp9EY3ymtQVLM
s5MbJqj6qSu5v+EZis8BJ7vwOZrYyMtBLu+HdEbHQrA86c1wu1qK2KNvXqPkdZs=
=yXQ/
-----END PGP SIGNATURE-----

--aoTbOZUmF9JI49gR--
