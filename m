Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaLCUTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:19:50 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47472 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaLCUTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:19:49 -0500
Date: Wed, 3 Dec 2014 20:19:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>
Message-ID: <20141203201905.GO7712@sirena.org.uk>
References: <547F3CAC.9050105@arm.com>
 <2041200.ZjakFFAZAU@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pmewarBF2ZzreSyu"
Content-Disposition: inline
In-Reply-To: <2041200.ZjakFFAZAU@wuerfel>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] ASoC: dwc: Add devicetree support for Designware I2S
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pmewarBF2ZzreSyu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2014 at 09:13:18PM +0100, Arnd Bergmann wrote:

> I don't think we even have to worry about the platform_data case here:
> the only platform using this hardware in Linux is arm/mach-spear, and
> it defines a device node with a binding that is similar to the one you
> document here but that is not implemented in the driver.

Not all the world uses DT, this is a DesignWare IP so it's likely to get
deployed widely - potentially on PCI cards and things like that.

--pmewarBF2ZzreSyu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUf3A4AAoJECTWi3JdVIfQH4gH/R3yPL0BX9ABaSL9ZtwgNQXC
PKfHlsCE3P24RrJ7Tzy42n8UkkZv1BWMq1wLGAp8ZQ1foep2BCdPlD+dcmeKMe/S
/g/8X7KhJ8j/sT2Hr6z0M8oRQfuagV6/Y9rZZu3HrymOB/PiPWUGvq+rejcuHqGH
tbtchpaAquuNW3QhPT42s1I6+iryoes83Kx7dB6pegQMJNUDrmaiFmrXQnb6x+NU
98Q8YOOtoFq79+KqQfTVMK4Auq1bmkNouj07tCdKhNoCZcPNdxcXQNT4BviWtTAb
pw04LM75ZoyoVgb5MPCEnMdlffP14PdJJ179/UdFy79qXhTydsZhnFFLTBzg7Ds=
=Cm/k
-----END PGP SIGNATURE-----

--pmewarBF2ZzreSyu--
