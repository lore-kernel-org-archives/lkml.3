Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab3GELpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 07:45:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47498 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab3GELpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 07:45:21 -0400
Date: Fri, 5 Jul 2013 12:44:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kiran.padwal" <kiran.padwal@kpitcummins.com>
Message-ID: <20130705114456.GV27646@sirena.org.uk>
References: <1373024862.3233.63.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N5J5EYBkERdVQZxU"
Content-Disposition: inline
In-Reply-To: <1373024862.3233.63.camel@matrix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: da9055: Update driver name to
 fix breakage due to pmic driver with same name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N5J5EYBkERdVQZxU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 05, 2013 at 05:17:42PM +0530, Ashish Chavan wrote:
> This patch updates i2c driver name and device id of da9055 codec driver.
> DA9055 is a PMIC + CODEC and currently, the corresponding PMIC driver
> also registers itself with the same name as codec, i.e. "da9055".
> Because of this the codec driver was broken. Now codec driver uses
> "da9055-codec" as driver name instead of "da9055".

>  static const struct i2c_device_id da9055_i2c_id[] = {
> -	{ "da9055", 0 },
> +	{ "da9055-codec", 0 },
>  	{ }
>  };

I can't believe that you've tested this.

--N5J5EYBkERdVQZxU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1rG1AAoJELSic+t+oim9Jx4P/14OzdHSXQCGe74jOSGjR/uM
dPk1C5SneRbpPSZUW8nw+4AfqXrsbGicSjcK0vWXOEPgr1tOGOtIJQYIJIg3Mbjb
aFnehJ3PMlbDbLubrs3mvUObATKPljfnIOfWVW5iCqx4qea0SLDBFYtbxaAf6kpx
xqSaO7IbuOHLIyDHBkvhafNTDUW1k/FNoBcl64EyJ+P8xAPJNIHG6lQIdBZXzbIJ
pbh9+497WqZ/53JjPCl4RzDdbQTUsXa4URC79dl2eARzMK8MdcsEAxKYf+ShsAd9
FgPCaYW28/zBOqcK9EptUaATQg2fPJoO1E1FyHxCU3rRZIY2JO1G0qrpnFJ0W1Sx
evmvUAbM6qe5+2bA0iFboxuXualACC00GL0XhnIETL2/cch+BH2ig9AFpVkhDgJR
x5bgAw12oj13xWWSJe7OiIoaFj/7UFoMxakSD2IJHY3Od40kQFWGYXu7lk9AQ59z
CHemZ3kPNlz8JSZg1TnYKY3UnmuJAcYcT21GbJskJ/w1ImtL+Gx0zQG5G8V59w3G
7n6Cp9QDUfjn1QXX5ZpusjC7g4SFOh2dQn4g28+MjEkb9xwGpBbbxykFk3mquMiC
EaZ1VQXeuLnpvXndL8oSekKUAoyltvIsyQNWsA8VbSXNc8SL22+7/hIl8oUoFzR5
pnkNY8nn/FpbBogDMfh+
=CPM7
-----END PGP SIGNATURE-----

--N5J5EYBkERdVQZxU--
