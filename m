Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab3IJKO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 06:14:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46571 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3IJKOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 06:14:25 -0400
Date: Tue, 10 Sep 2013 11:13:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Ni <wni@nvidia.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130910101359.GX29403@sirena.org.uk>
References: <20130909111242.GW29403@sirena.org.uk>
 <522DB253.6000707@roeck-us.net>
 <20130909135022.GZ29403@sirena.org.uk>
 <20130909155043.GA18975@roeck-us.net>
 <20130909160237.GR29403@sirena.org.uk>
 <20130909161735.GC18975@roeck-us.net>
 <20130909203910.GV29403@sirena.org.uk>
 <522E9A85.9050803@nvidia.com>
 <522EA51C.90706@roeck-us.net>
 <522EB0AF.9030708@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FXy67hQeDqxxjNHK"
Content-Disposition: inline
In-Reply-To: <522EB0AF.9030708@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FXy67hQeDqxxjNHK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2013 at 01:39:59PM +0800, Wei Ni wrote:

> I think the device need time to wait stable after power on, but it's
> difficult to get an exact delay value, and this delay may also relate
> with platform design, so how about to add a optional property in the DT
> node, such as "power-on-delay-ms" ?

This is something you should *really* be able to get from the datasheet
for the part - this sort of stuff has to be documented for hardware to
be used robustly.  It seems entirely possible that you are working
around an issue with the regulator driver you are using not correctly
providing its ramp time here.

--FXy67hQeDqxxjNHK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLvDkAAoJELSic+t+oim9MSUP/2DkBcUsNRe50iXk7odxm3Cx
Gy5Hmcjm7Krm1uoQhwuaYEUegbqb0KFNGbIHdy9xKtg5QYRn4kWLGwabrFU/JMe1
lRYDcV69Tj4ys7HyHQG6ek4aypoAJ/IR8fAPeUGvtOiUIL0/6hcurswwO4YUfPWP
VHhhiDAl7lt5eDjLaEJ+ZxjCpZhc5QgvyHqM/maDh8IaeZjPJT8ftnuJP1kCstIV
Rxb5/hdfrdkKgkKRKEqxeWYNsVW+wU8PvJsnZgFdp27Dnh9pv17EqNEUTSFN3SsO
LyjDyUw2YpcWjjL2kjlGNKaUz/5Zg8lQXDLmOeE1oxQpUTOTuLstnSpiZ5nMJUBg
gTq05caZ2zRBRZRKZ9eQ7cZJ9/uvs4tsHV+SJqJeCSEuluzw9IXmlT4USBOaONFc
A7OvGJi6UtefSoGSWpE/jW7zkdmEh3Ir+eGUHchmeJ8PKgURJbf00GokAd4Vol9J
tTjOeqrMBd8VayCD5fagOWPWXWUAjArP4+jG0oOPqJ1OfBG143d5+VWfZ2DFjm2P
DvgCXfih8FCwgRKCorbWdXf62V9CRv+TebThQp9HNOqF2iY2xM8a1vAHjJWO9xUv
iabOQGodVDZYeve8/gOnL0tDgR7jCKmJdb2X3IC8wKU2KuIRPvVV4YqMgU10i8/0
SGtaN6HNhDpTwHzRQNov
=1txa
-----END PGP SIGNATURE-----

--FXy67hQeDqxxjNHK--
