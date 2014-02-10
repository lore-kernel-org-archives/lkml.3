Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaBJOv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:51:58 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40101 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaBJOv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:51:56 -0500
Date: Mon, 10 Feb 2014 14:51:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Message-ID: <20140210145145.GO1757@sirena.org.uk>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <6a398d176b0b2bf8792d27bd5e2995fd96afb32d.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <20140210134310.GH1757@sirena.org.uk>
 <20140210135939.GA23141@lee--X1>
 <20140210141400.GJ1757@sirena.org.uk>
 <20140210144234.GB26697@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2wyf/X6i9kneRjiV"
Content-Disposition: inline
In-Reply-To: <20140210144234.GB26697@lee--X1>
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


--2wyf/X6i9kneRjiV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 02:42:34PM +0000, Lee Jones wrote:

> > OK, but it does need to go in as a fix targetted for stable.

> Ah, in which case there's no need, as I don't have anything in my
> -fixes branch with touches this file. Simply take it in, no problem.

I'll do that - thanks for confirming.

--2wyf/X6i9kneRjiV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+Od9AAoJELSic+t+oim9i0YP/2vivd6xlOa6KrlEZrOTWnjI
gt0wy3dcpFavwlzW6HDColIOmHN5QAP+j5n3sf52mCN3mC4MsIwyatq9Xu88YERf
SS4EU0vGzn30N2BSGg6HYsz6XqR2Dw0yesttiRDqHsqP0IHBDtgkz3nbi69B3EGr
pfgqFmPE95Y1KzGJvmMcbtM0Pg5Vg0E+hO/gpr8OK9GbY3M67Kn3e4z88IS6BnI/
u66XfmaBr8CxehCJfK0qbtAXPQad60WS2ynOXvIgxGcj3L+g+oNk3IyNWxc1YS1c
mw26EMiNDARy2fw6Px8mhGjQ3CAAziRyIgkJtWaZyJBIRZjdNwwPjHVTMi/GaD7M
lLEbQ1TsCXP0urA8vs95FyWmeDeAS1bX5jIosJ9LaZ79YIf5yDTWNN2xZy8Pl1+J
v2+ec+pfpGVdgrxsuQKSffxQjRs/gsJuD1b++igMIve03L9ACSRocLH2JNxLzdr1
oEmHK+fyp7vZqRLtK0QzMu48PPYZGHg88j1cbElBXChTFgp8AF+a9GW5KLbUD6iy
4MKhehdda2XXGhZDNAGw4XcgvUZR6oqOOv2aRHDHcWbgPB9SetvKEisMNW7Isyn6
X4dLIfgOZ9al1LrUH+WxB3TaPXmHpE84UNQ+qoU+wlrvuHqrE+DMdXd/Gaw7XsHw
+OOijylmSsi8d2d6DspJ
=6NX5
-----END PGP SIGNATURE-----

--2wyf/X6i9kneRjiV--
