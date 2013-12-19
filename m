Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3LSKSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:18:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52049 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3LSKSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:18:30 -0500
Date: Thu, 19 Dec 2013 10:18:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20131219101803.GP31886@sirena.org.uk>
References: <1387444262-26456-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYfJCIN5rqlfy3K0"
Content-Disposition: inline
In-Reply-To: <1387444262-26456-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] mfd: wm5110: Expose DRE control registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYfJCIN5rqlfy3K0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 19, 2013 at 09:11:01AM +0000, Charles Keepax wrote:
> Certain use-cases require the DRE to be disabled so expose registers
> necessary to control the DRE enables.

Applied both, thanks.

--WYfJCIN5rqlfy3K0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSssfYAAoJELSic+t+oim9PhYQAJPiTYAXK6Iq01O0YhzYf+oy
XZrhhk/QZzEO68zqbwQ+DurSkk3gT8WoNNxqoXdkZxh2zsJBHxpffhmwZTIj1X4P
mOKKvRIiteWK8N9tW8J4u61vDkmWMtHS0pJubjQbMzk/dy+Vp5Lbf4lF0u3g7Wl2
Zx6w1sK9zZhhMQKhu5YNH2rqtmlmyI1g5SXsVvwvc76xhVCmWpZlPH2Oze9LKmSy
cBV4P3xJpBRfDJ2YtOYOijkt5dv8X2rRGYiskZKxCmFyopFvuZn3gn4jMniQSg7d
zbEpeeHUcTxCqenTh/c90oBfqVuhcneZ1tD8pn2bLmi4Kbm3xc6MnoGpE0GL83D5
g63Gp23WfFWEvlmGliUn+b5V4YCP59+wVRT8dKSIZxnRnl3cmrVRIrbkQ2DwxAxn
vznmsfvV1IHcp6GW2wWt6MXpXFeBKVJSvkvng5CUVrjEAB6gfdgqjistNT5+OnHy
OqV053CADQSU96NhR9zAkxycr6YFtCs+30BIUvk04497qM1ju4piorDE0jwWFJgy
zxG6FqcR4iPzc3jYPlPL4cZb1fgHtrALnP9ytmhn05Z8PN1dppt88XZo3z5lZWVe
KWp+P5gw+DhNhAe3CksQ4ZZYzz/D7AXzxZjdqe3H9Q+lT/SqJKYdncb+4abgFwn3
va6icxAUdyW9A95d4eXc
=i15E
-----END PGP SIGNATURE-----

--WYfJCIN5rqlfy3K0--
