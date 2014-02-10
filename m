Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaBJNng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:43:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40041 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaBJNnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:43:22 -0500
Date: Mon, 10 Feb 2014 13:43:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: Lee Jones <lee.jones@linaro.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Message-ID: <20140210134310.GH1757@sirena.org.uk>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <6a398d176b0b2bf8792d27bd5e2995fd96afb32d.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nCRcqX7cEx7rr7Pe"
Content-Disposition: inline
In-Reply-To: <6a398d176b0b2bf8792d27bd5e2995fd96afb32d.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/8] ASoC: da9055: Fix device registration of PMIC and
 CODEC devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nCRcqX7cEx7rr7Pe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 06, 2014 at 06:03:07PM +0000, Adam Thomson wrote:
> Currently the I2C device Ids conflict for the MFD and CODEC so
> cannot be both instantiated on one platform. This patch updates
> the Ids and names to make them unique from each other.

Applied, thanks.

--nCRcqX7cEx7rr7Pe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+NdrAAoJELSic+t+oim93b8P/17Anp84nsAFWorx9xQf4jiW
05Bn8ZIUfZE1UqyyozfwO1Dw3W/EBzEZm0Y3EGHKabKaRp4zYHHcp5vSqi2DJnDb
y74BFAhX3Vr0/A7mKVe05jaGwHtJa5aMLl0XC6j+ZOT68tDz7WQuK+y5cV29rfr+
AyBd3JhugJlQl3FctoQ8HGtVf1/ZUT01jHTZ0F0fX4nGOIF7H+mf0DxPitCcZfda
hkb/rD1VYkN+LiN+vB3yHgnBT6zASIPi7DghfDwLTlcbBIWwxeFCqU8l4bR7qfqD
cS1Q9Ac383CYEpyi0s6puCxgEj7UYpnAcabRv3cStWiI+jKMyxXkyITwqSanylfh
/uFUBlBOorVC7OWnNWvRXi3epNCCr3GeWxDcSZ20toDYXrIMK9ZYKN4zJBGQu15W
aksoRqMA8d62zkCwZkNt2PexkNUFGHDPrIqEJZnmikkSJ4aFgsJsFAYSsKZi8rWe
KdJzSQV++dEb5R47SDnxLKlZnJoM8uGWP0Y9c/MycMDWBZLXm7QWDaY7vuTXQD0d
8E/fCOJU+AevCU/HhGcy5RB0VP/tBMyQ2x+b8PlfbcKMcCpevdI8BNoQpF93vey/
7UvmqIyLSn4pugWNHqDXwvBhzTqcplRLKGAhC3bN6pveP1JNi4NxS4be3ei9fpUs
882sMbyf/va0TWO7byoc
=Vkel
-----END PGP SIGNATURE-----

--nCRcqX7cEx7rr7Pe--
