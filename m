Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313Ab3FMOrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 10:47:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36501 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab3FMOrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 10:47:52 -0400
Date: Thu, 13 Jun 2013 15:47:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>, devicetree-discuss@lists.ozlabs.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <20130613144726.GY1403@sirena.org.uk>
References: <1369246717-4167-1-git-send-email-nm@ti.com>
 <1369246717-4167-2-git-send-email-nm@ti.com>
 <20130610103131.GR31367@sirena.org.uk>
 <CAGo_u6qTiPpd0DDe3jnPh_UxTwox22azhcMGy=fftL8H+DGeyw@mail.gmail.com>
 <20130610164905.GJ1403@sirena.org.uk>
 <CAGo_u6ov=yaCwt8apbvW57ErAvhgUBHHw9gwADBC1fJUrfucUQ@mail.gmail.com>
 <20130610180150.GQ1403@sirena.org.uk>
 <20130613133950.GA32174@kahuna>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5LZCLy8Sy7WgNZQM"
Content-Disposition: inline
In-Reply-To: <20130613133950.GA32174@kahuna>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 1/4] regulator: Introduce OMAP regulator to control
 PMIC over VC/VP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5LZCLy8Sy7WgNZQM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 13, 2013 at 08:39:50AM -0500, Nishanth Menon wrote:

> I am having a bit of a difficulty trying to understand your concern
> here.

Your device tree for this stuff appears to mostly consist of repeating
the description of the PMIC that we already have - this really doesn't
seem like a great result.

> Problem statement:

> OMAP has this weird custom h/w where one programs the voltage and that
> voltage is send over i2c - this is not same as Tegra's lookup table
> array which automatically sends out entries, in OMAP, software has to trigger
> the voltage transition

The basic idea that's important here is that you need to figure out how
to tell the hardware what to write - how those writes get triggered is a
separate problem.

> If your concern was describing PMIC parameters in dts, I can easily move
> them inside the omap_pmic driver and provide required compatible flags.
> If, on the other hand, the entire approach followed is flawed, I'd like to
> understand the rationale for the same.

That's the biggest problem I saw so far but to be honest I've not
drilled down too much into the specifics.  From my point of view the
main thing is how this fits into the frameworks and so on, having the
register information in the DT was an alarm flag that suggested the
overall approach was a concern.

--5LZCLy8Sy7WgNZQM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRudt7AAoJELSic+t+oim9cMgP/jISyaqjXOWlKr5a3glq/Z+n
ryTsbnEsFKBqKwK2NyKkcypjbkWp5hzHwhZM+QHqpLyeunfRbJu+8Y7Zg+E99EAf
jiIFhLJ8kZllQZJFlhHnvX54dS38p6/0O3vM4OcR4OsjmIHjPDYhgqFbmVTWogKP
Am/JZOtYXg6yMtzZRW+TwV30FmlO6rm8YZ5aejtC6kH45EobKWeXI3wcRSvYeJYU
lbSTid1x4gvNzHzTps6l/06lFl2RE3/w0abNCrF9YxvP99Mr7I5Q0X6ABFQHUj7G
0St4X9QCmM9ySy26tLVh4lDqBwem/6P1m67xrg50+TVzxRn97ejEFnwXPPXwhoKT
rHy/KfHYg+Cu/JPF2h+88yfSZoN722bP8e/2akGY/Kv4ZGAkUpbCX7Lj6bbMyu/R
bFQW1d0bCn9WqbevBgG4VrDqzrCOx0gALgXSQnPIY9E7b79s+yZsTuS9rf4VS06U
9ekPl8NXphKkF+vIiou60zifHB+5mfcMHxLgWGu6z4H0ssgTT2da5DL58NmP40gZ
TN2HxNeBMaTDMLIlEOLgRV/WUUnT6GMXeDTY1LkeARs79+gMoHjF/do+4DuG1tDy
hI33kNKyps0YK2hq/9Jfos3sX3kXYKMnGv5cbLUF0V+nTqQPdrcEEXEo5ie5sTYN
4JoRvvUwmeORCCAqVkk8
=L0BV
-----END PGP SIGNATURE-----

--5LZCLy8Sy7WgNZQM--
