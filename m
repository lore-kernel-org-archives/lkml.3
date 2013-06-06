Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab3FFKTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:19:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55229 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab3FFKTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:19:30 -0400
Date: Thu, 6 Jun 2013 11:19:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Illia Smyrnov <x0194613@ti.com>
Cc: Illia Smyrnov <illia.smyrnov@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Message-ID: <20130606101919.GQ31367@sirena.org.uk>
References: <1370432398-7796-1-git-send-email-illia.smyrnov@ti.com>
 <1370432398-7796-2-git-send-email-illia.smyrnov@ti.com>
 <20130605115734.GY31367@sirena.org.uk>
 <51B05FAE.60508@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NhnzZsTWd+R/yp6D"
Content-Disposition: inline
In-Reply-To: <51B05FAE.60508@ti.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: spi-omap2-mcspi.c: Add dts for slave device
 configuration.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NhnzZsTWd+R/yp6D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2013 at 01:08:46PM +0300, Illia Smyrnov wrote:
> On 06/05/2013 02:57 PM, Mark Brown wrote:

> Turbo mode gives the expected results not for all cases. There are
> some limitations:
> - works only if a single channel is enabled (no effect when several
> channels are enable);
> - improves the throughput on RX direction only;
> - effective only when a transfer exceeds two words. For single SPI
> word transfers OMAP TRM [1] recommends deactivate turbo mode.

> So it is useful to have the property in DT, that allow us to switch
> turbo mode off/on for certain slave.

Why?  These sound like conditions that can readily be detected at
runtime.

--NhnzZsTWd+R/yp6D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsGIkAAoJELSic+t+oim9RocP/R1iT4kg2Q+gyyMmYSWK+dyY
CYCn6FZ9drlQKYYaQTqnr8eCpDL2/6gPzRbF+xhBB6Zp1AGedlT9qdvQqySVGxCZ
0CjtipwXfm7n+Nn5doXlx+SbpvUtKSJBY4yPR94/tEBJvshw5LODBghMiUgIPLtv
kx2b6ot7ma+Lliw8NUa7Js+dDCgArYz9dTK8Kxezz0/Ujlfv1eeu9SuhwakaT5eQ
JvsgqNHRSPgkcWpstU2zOpiqV9Fd9SoyxD7SJ8RcKsrKJ1zFP82vDMQOOG7oBcMj
n3/qVtzAiPl1Vmj0qljZsf3EhLzyxRBxPtr3oRx5KfhaRI9rh2aOrFpy92K5L573
cT9FOiGC9zvr7mCuPA1sGsOBl7zN7RzBP42meS4qSJbVUNpMFvZlr+bCGdUluC2x
fDYHoCKyJGkvgU2esotWg9/bTfe5wGbGu1e+ian5bJHZMagfnAkmw3Yz1abpXfgI
zZAm7uqu6g8Se+mHqaNv4WeHf+QdT9NU4qXbcEro/36YyP4bn1KI2CBjyNa2v3ov
DOFEezQO6pUMmhVGM7jG9lfLFXj+Ara5i4VrfMb7KJKveU49AKewVUOM7E1YCOpV
drZahuIHYPnUIFOB/lddMYPJ2MketnjBV7qW1ZUO+bay9jzPKQfl1/4b2Uu5WMSa
rMamq1XMSMk1SybCmHgB
=kwNA
-----END PGP SIGNATURE-----

--NhnzZsTWd+R/yp6D--
