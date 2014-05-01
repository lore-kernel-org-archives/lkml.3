Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaEASsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:48:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54345 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaEASsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:48:03 -0400
Date: Thu, 1 May 2014 11:07:38 -0700
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Message-ID: <20140501180738.GP3245@sirena.org.uk>
References: <1398789430-23897-1-git-send-email-p.zabel@pengutronix.de>
 <1398789430-23897-3-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U2TwCo+MHNvvM16y"
Content-Disposition: inline
In-Reply-To: <1398789430-23897-3-git-send-email-p.zabel@pengutronix.de>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulator: Add LTC3589 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U2TwCo+MHNvvM16y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 29, 2014 at 06:37:10PM +0200, Philipp Zabel wrote:
> This patch adds support for the Linear Technology LTC3589, LTC3589-1,
> and LTC3589-2 8-output I2C voltage regulator ICs.

One small nit in addition to the vendor prefix thing:

> +static const int ltc3589_12_ldo4[] = {
> +	1200000, 1800000, 2500000, 3200000,
> +};

This could use regulator_map_voltage_ascend(), though for all practical
purposes the table is so small it makes no meaningful difference.

--U2TwCo+MHNvvM16y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYo1nAAoJELSic+t+oim9rzwP/2EXtJJbkfZmcc1C/+hnkKL7
xxVzJk+NJgk2uJq4Q3S/It/TyWHPDO5v+tEr+99u/RkUNEzxpk+lsK8YQJgRFyyK
gvmoujDy/YIXHBNVgPUVEOIDMLjYMw6Vpk1ox7SVmo6vkTYGFkJB5LLyrB0yxlUt
fyZNP8XHsNNvUCcHGVClgOyhcQ5kZp9Y7KAANMb0Hohy1ZmD3hr0tonZPTxepYpr
vOKEeEnZR76mQhW9LUSZDuI4WCkOq/9+OakzfBvqgSidWzbLeA+XvNtOAruD0hAK
KOZUceZS7IlW3sXvnvj0qONlCyK57TS8OX0OjaxVk28E5oUTXgEfb2PDJS5IrmW4
Cx1cQnoM5KazmHGUJ+4ylIGJS1uS3TdXNBf1M4gpcwRRqmuAwz+RPTDiLC5iflox
KKvKedx0fpg5bMYq09pkvovpsXsmYc/PjOyJvO3b9JcC0vEcWpOeHlX5z4kBVXv6
Sh4xmaZ1joFUM7qVujQ2j37LO/uzvPrN1qj85+lRPuWakvzcWwUI8l9fgxAS/rwi
1wapgdvpGrDj/fSmQ+yeqzXmaNTM4irhSNT4WKrJ3QFaK7rrZAs9ptpvRnUXsdah
5kvniOx5XuVRllwNKBPYu6BWm6Qq0esQbXDs6VfGbMntIUBA1vsrdKUXVsJpx4vc
/YOqWkshwX8MZygfuWKO
=KmH/
-----END PGP SIGNATURE-----

--U2TwCo+MHNvvM16y--
