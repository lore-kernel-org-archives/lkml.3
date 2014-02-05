Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaBEOOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:14:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36314 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaBEOOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:14:20 -0500
Date: Wed, 5 Feb 2014 14:13:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Wolfram Sang <wsa@the-dreams.de>,
        Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        linux-spi@vger.kernel.org,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Message-ID: <20140205141358.GJ22609@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
 <1391529538-21685-6-git-send-email-ulf.hansson@linaro.org>
 <8738jyu1h9.fsf@paris.lan>
 <CACRpkdZt5+t7b0_a__2kJP4V9PS2cyXmguWrST+fzbKCnosi7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NN0dgmCSDRRJ0kp/"
Content-Disposition: inline
In-Reply-To: <CACRpkdZt5+t7b0_a__2kJP4V9PS2cyXmguWrST+fzbKCnosi7g@mail.gmail.com>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 05/17] mmc: mmci: Put the device into low power state at
 system suspend
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NN0dgmCSDRRJ0kp/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 05, 2014 at 01:49:49PM +0100, Linus Walleij wrote:
> On Tue, Feb 4, 2014 at 8:22 PM, Kevin Hilman <khilman@linaro.org> wrote:

> > I'm trying to thing of a good reason to not make PM_SLEEP depend on
> > PM_RUNTIME for platforms like this.

> Isn't the typical Android platform using PM_SLEEP without using
> PM_RUNTIME?

No, not at all.  Android does make aggressive use of sleep but it's also
highly desirable to use runtime PM - for example you don't want to have
to power up the entire SoC simply because the system is getting a new
e-mail pushed to it or location updates, most of the hardware is doing
nothing.

--NN0dgmCSDRRJ0kp/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8kciAAoJELSic+t+oim9RHMP/1sOol6uyBPyCeoYAIDa1zv3
JmyludROrGMYmnRCYTAIu9P656WfkYpjqrXJW2dQms76B9XCgkCoLedvbai3acz5
CFTUVv3IPjSARmO6J73+9K6Ivpy2vraQCrfA3bkVyzKApdtl5SWidjRMH6ISKpS+
m9hDTzc2ND0OJuLt/xkSc2khGsKIcFrNkjHAvfePRzzwOaCXXC1RRcU4CpYHSG7g
olGw5HX+u5fWbq8o8TNKGtKlAVLR24KVafwjBXw3/RCSKAGAy1kgYsXLCiAkrnQ5
nnTcUD4Xyw+jT1roIPONZr9cKjpMka8aG6k7pJO3ti5oztzV1mO6MTpAApm2Ww8W
91D5GJJNrNROnHhJlt8etNPrT0Xr52oUX+Dy03pNqYEoY5y4yhUOFM1QOIc7/l0C
KBvVFZ2L5asB7AqXvz0qCvvlZgorjwPTqWhvOfSZYGWcI/WyIh5HvxZ5aESjttBM
GFLOmLt37snOuzyZYtDwCh+LxFmzfdMNega2lNL20AXjLZah+/nXGUTQ/LFFxoH2
HsCHOnyh0ELcEc+Xk4nTCY9X72k0hoZdlwMrhAFuZ/NhXR8YQs010Vsd0+loIH7e
+ekxhy8RJYpr8QFRFPrJYWR/68wlRSInxWMHXlDu4Dkc24qa3Zkv3sATzzSQJpfI
8YT+IczGa9wjteaJOVBG
=8X+O
-----END PGP SIGNATURE-----

--NN0dgmCSDRRJ0kp/--
