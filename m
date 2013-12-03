Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3LCPTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:19:13 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37432 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab3LCPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:19:11 -0500
Date: Tue, 3 Dec 2013 15:19:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Keerthy <j-keerthy@ti.com>
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, grant.likely@linaro.org,
        lgirdwood@gmail.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Message-ID: <20131203151901.GC27568@sirena.org.uk>
References: <1386053006-6480-1-git-send-email-j-keerthy@ti.com>
 <1386053006-6480-3-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXF8SilVSrRwayWj"
Content-Disposition: inline
In-Reply-To: <1386053006-6480-3-git-send-email-j-keerthy@ti.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] MFD: TPS65218: Add driver for the TPS65218 PMIC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xXF8SilVSrRwayWj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 03, 2013 at 12:13:23PM +0530, Keerthy wrote:

> +static struct regmap_config tps65218_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +};

You should consider using a register cache for at least the interrupt
mask registers, it'll improve performance.

--xXF8SilVSrRwayWj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnfZiAAoJELSic+t+oim9l48QAI/SHk/6/1208l6DU5JwCTDV
Q7mEq14NYLImEwvmqjR5mqXkDXULmmtn+AnuweHzkbx6wVOH7KENQQgiuge0dCa9
8WzoePzk178iH2yVMhF4acx5PyNG0WrVqRdo4DZKxF1B1r5S7LZDSrtjhM8uvM2D
/aO4wg/k11Yq3+9YFXhXq/NTEPehI9dWktHm0+ORiRmjKdvoJQ++fwBWKg/MbIRu
DDF6y+Yq0+WZqs1ifVdn3F+J0XZ+kPW83umBdBm4VmwAm9sczbyCfFOkyAW1hpQC
4nfxFYChS5KMbG+SQ32PJNwhrtZdLWU2r4ODMS0lj5oeGUQlT/ioksgksoPwW6dc
cFePpnRJ8Z/R3F4L65A5+pxmfsSV3l/CQrVSGiOREeb5iPXGhIJQ52Vf4dijecfx
L/JUJyv9bZy/TLHg9KeRlPHwv+qC5r/myp/7E0ggSs+H52LCWmQweD+LC00lQq/B
WoX/uhZsqZNhIAn8IpZe5ANievd/HySqOx4ZPyvcLXw7GgbMYHpN466y+rlvXlZq
GnbOOvHimHp7pM1MrjIcuTDQ567xESCXobYv7PJDtRhfHNF37UptefWbcR8sbRtb
u6cWdPfhuSYOyjoFKHo5XMLP2cx8xpTbD46LN4Owv1lb5ddxxHWJATvkUc1pzemY
Ro0epDAROD1auRNMd9FD
=Yzm7
-----END PGP SIGNATURE-----

--xXF8SilVSrRwayWj--
