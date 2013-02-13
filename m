Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885Ab3BMLf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 06:35:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53918 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933818Ab3BMLf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 06:35:28 -0500
Date: Wed, 13 Feb 2013 11:35:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        Kevin Liu <keyuan.liu@gmail.com>
Subject: Re: [PATCH 3/3 RESEND] mmc: sdhci: check voltage range only on
 regulators aware of voltage value
Message-ID: <20130213113525.GB5062@opensource.wolfsonmicro.com>
References: <87bobqrcb4.fsf@octavius.laptop.org>
 <1360656096-1671-1-git-send-email-m.szyprowski@samsung.com>
 <Pine.LNX.4.64.1302122309470.14434@axis700.grange>
 <511B41B8.3060506@samsung.com>
 <Pine.LNX.4.64.1302130844530.18535@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1302130844530.18535@axis700.grange>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 13, 2013 at 08:45:56AM +0100, Guennadi Liakhovetski wrote:
> On Wed, 13 Feb 2013, Marek Szyprowski wrote:

> > BTW, mmc_regulator_get_ocrmask() won't work with continuous range regulators.

> This seems like a problem, that has to be fixed...

Indeed, what's the issue?

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRG3p2AAoJELSic+t+oim90HUP/3JVw/VgCaEP0EOPS2JeLDZu
mYKG9DA5W3t7kVCScEZiDl3OepF3Q5NAyAwXxbE7dXZqzHD+PVJQV4T262IwMMIC
5/leGCmU932LKBUSlmOsXaasiJdaMKBEsr81z/sfo/a99wnhSX776JcmwmF9t1F2
BKHIoUJk/OH5S8gBS9tFQOTNIsom0LVElco5TbQt5bqFM89+MXb3ksGS3Cz08nqh
S+ZuDXv84gaw2cRFbUJgAEVG8Acn5zc+nJNJ1yCjglnlO5m44AZ/sNTgmZBdjUZ8
JwNxwpCPGV7Y9ALELOK75ScMZkFh4Wsl0CLGecxC6h2UfIKFFhpw3xX5xszAC/TM
srKTX3EmdJ1SLbb+nh+RrOzyiYscVlSaZqiqu96wbUOSmAtH3ytQFXEmP84aEtf4
hvx/LMjBPpiXsQvwOHAL8WTUgVkrdyaqcDrmAYhmfq4E04nV2w+cnMzKrZK0h5wO
gURVxq/f5QcWPaX0fZJzhi9f0m5+lOt7/qCfKd/+iYR5XL/B8TZgzr6MyvW2+5y1
HTYEUE+AUdqMo1ZDqUu5CmM9y5GhfI/oPYUMflFfz8oGl00yqqs0y735tYL5vTOt
EpTT9KG75/DppaSWYjliFPTrWNHjHz50Vdp71cAEWcsJprY+PWE6TzizB3T0HD8D
AW3JqqGQee6cSTSc1laL
=K1Hr
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
