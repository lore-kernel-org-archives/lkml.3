Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaDYQL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:11:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45251 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbaDYQLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:11:52 -0400
Date: Fri, 25 Apr 2014 17:11:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140425161138.GR12304@sirena.org.uk>
References: <1398441341-19436-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Na2NVb1+pUrRV9Hf"
Content-Disposition: inline
In-Reply-To: <1398441341-19436-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: arizona-micsupp: Fix build errors with
 CONFIG_OF not defined
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Na2NVb1+pUrRV9Hf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 25, 2014 at 04:55:40PM +0100, Charles Keepax wrote:

> Some of the OF handling functions do not have empty alternatives defined
> if CONFIG_OF is not defined. This patch ifdefs out the offending code.

Which functions and why is it not better to provide the stubs?

--Na2NVb1+pUrRV9Hf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWok3AAoJELSic+t+oim94iQP/0c4gBiJCuPVsCUxqrh7bgSV
q08Hwy2kJLhpq65y8pWyA4xGVdkjQvLXFVKR+Yd2vnsdkvFE9ZMsPs7KReotYjz2
5xCKTN1BaAd0xhvx6SahmVscHIKvkrFfkgSqvZvD2/GUilbM6fr936Nov2rVmN5I
EGa49eupyCag0/6Qhhpznq+GzFpaoCGJrbUBXjMIuLHa1QjK5b5dma7b9pZRs482
BEil6vc/EdUUo8KfdmkiVcOQ8o7JtVq3ke5064bK6OwCrk5EYg1AAbvl+e5kyi7P
cGurbuxdSLxl7qjeKDStKLK21PkCX835PZgvEtwhwU5xDqN9VJpTkAA5LBAmzBZs
uWj/ZtzKc0ilxmPu1EVJWqIOmuKCsInEB3+Kdk233hIUdIbnjOCrguvyWyt8A9W/
xvgZGBJB4QEdeHjPWBqSCiotOaA7ARV3QZi93M8GgIPjMRh66dt1eMLXWr43KLDS
RQJJL6bgNuoWNml7bp3k+m4ufmRtcRcTi40QqbS2AUwljFAZcD4LjXVM19Aq+EFj
gjgeslgjUkcQ8DY280+Zl+N1q0S9AxXWIxJzVFdLYx55Q/Yh2FSch8W8fBL26OE+
/Tx1uRmWneoOatxCw5OxURsNKwiXmt1L+0PVvZZcNa8piTBlI9q9ut0DXm8aNDNK
sCox9lhW5by18QKy8W9s
=nwog
-----END PGP SIGNATURE-----

--Na2NVb1+pUrRV9Hf--
