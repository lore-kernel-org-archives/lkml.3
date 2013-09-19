Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3ISJ5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:57:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60861 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3ISJ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:57:09 -0400
Date: Thu, 19 Sep 2013 10:56:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Marc Reilly <marc@cpdesign.com.au>, u.kleine-koenig@pengutronix.de,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linaro-kernel@lists.linaro.org
Message-ID: <20130919095628.GH21013@sirena.org.uk>
References: <1379527587-14567-1-git-send-email-broonie@kernel.org>
 <1379527587-14567-2-git-send-email-broonie@kernel.org>
 <20130919091318.GA22389@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D+MycPccvPlP5/X+"
Content-Disposition: inline
In-Reply-To: <20130919091318.GA22389@lee--X1>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] mfd: mc13xxx: Move SPI erratum workaround into SPI
 I/O function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D+MycPccvPlP5/X+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 19, 2013 at 10:13:18AM +0100, Lee Jones wrote:

Please delete irrelevant context from mails, it makes it easier to find
the new content that's beenn added.

> On Wed, 18 Sep 2013, Mark Brown wrote:

> > @@ -94,10 +94,15 @@ static int mc13xxx_spi_write(void *context, const void *data, size_t count)
> >  {
> >  	struct device *dev = context;
> >  	struct spi_device *spi = to_spi_device(dev);
> > +	char *reg = data;

> I think this requires a cast.

No, you should never need a cast to or from void in C - it probably does
want to be a const char though.

--D+MycPccvPlP5/X+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOspDAAoJELSic+t+oim9FpkP/igeBTgdqLd2AM0jwuzRaaIp
feGipN7o51qlbvGEawz50qIkqrfiSiq0Zr1CPdvvBxMyE/uHxwMDxNazmDESL7h3
2kWHuMyhQuT0YIahFc/M/7wr7SszfCFNmu9NAT7pQtrGuBV19MkerPCFr3qVFQVz
OxWpQ1IZXraXV9t+DAq2o/FJtK6IZOO7QHUufY5y6UpkZIqIhvW8yY+A4XWgOylJ
Y0r88K9Ips1w729JUjHxZEF8u4KH6IMP/xMT04vO1YMXsmNKXKNAGRuAZex7NVom
eXSgeQgsEcuTkpHwd7Ny6AWepMI/0342BJHylDlJOSP1UEzOc3+Z+RPIFoaDqbzK
IxDjmq0deFWaqAaAIwVH37Ub5uI+/Kua2Lv/QlRfGlfZvxOQPI/RhC7GAtwc3c38
pqAEPyeKP+BVKuq6ipJ7+Y+PvY4FpGnhHSjJB7bHqR4mVfR3GHnQz3SmTe5TzfaR
7cf9hgidCEqZ+2zCroTCy3A0e6/hYur25ekZmNH+EZovIcFGxWLIkFYKI4U/PTb2
PhwFRM4RBGuFcrymMMdeToGCYNJZnbfO+XaQ5VUsZnSX9+0ooN0pDKZo3tn8MLhr
qbO0ghy5nXTahj0ABaJ1skkUk/vUW9OL7tJ+WwOEcUpCxe0fmhaTtfoPWFHDq3PP
YXM3I6yo9sansFj0gt3Z
=2/jp
-----END PGP SIGNATURE-----

--D+MycPccvPlP5/X+--
