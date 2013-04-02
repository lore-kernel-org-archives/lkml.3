Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab3DBIpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:45:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45626 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755183Ab3DBIpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:45:51 -0400
Date: Tue, 2 Apr 2013 09:45:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: Marek Vasut <marek.vasut@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: gpio-ucb1400
Message-ID: <20130402084548.GC23065@opensource.wolfsonmicro.com>
References: <1364586399.4216.312.camel@amber.site>
 <201303302020.44584.marek.vasut@gmail.com>
 <20130330232559.GA12864@roeck-us.net>
 <201303311919.06030.marek.vasut@gmail.com>
 <1364814403.4943.7.camel@amber.site>
 <20130401153247.GA13517@sirena.org.uk>
 <1364887357.4208.6.camel@amber.site>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
Content-Disposition: inline
In-Reply-To: <1364887357.4208.6.camel@amber.site>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 02, 2013 at 09:22:37AM +0200, Jean Delvare wrote:
> Le lundi 01 avril 2013 =E0 16:32 +0100, Mark Brown a =E9crit :

> > What the driver is doing is, unfortunately, the best practice for an
> > AC'97 connected device like this - we've got an uncomfortable mix of
> > an enumerable bus and platform data combined with a subsystem which has
> > never had enough love to work in a nice way with the kernel.  The idea
> > is that any boards which have the device will call the _set_data()
> > function in their board-specific code.

> OK but where are these users? I can't see any in the upstream kernel.

They'll be out of tree I guess, it's fairly common (especially for the
hacky bits like this) for things to struggle to make it to mainline.

> > Sadly we're a little short on volunteers to clean up the AC'97
> > subsystem so this situation shows little sign of improving.

> Well Marek proposed a cleanup which looked good [1], several times
> apparently, but it was never applied.

That's not really doing much for the whole AC'97 problem although it
does help a bit with that particular driver providing the AC'97
controller driver it's used with has had support added for passing
platform data through.  Don't see any reason not to apply it though,
you're probably just looking at a busy/missing maintainer problem there.

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWppbAAoJELSic+t+oim9mlEP/033oNyDZHPEr+Mdc8sQhBVx
hNw35zKTfKMSLwlfpZyBswBFNFYcH8C0jUfzHQZZ82eyKxBp3XQp/aQeC/KZrYPv
yMCUOIx9xVyO//z4N+NjW2TV6GrnZgBaPC6s2HVSGwta2Ab27CxIzJDOcDumQYMy
8FthzUKKhhuPuGkCLuqO3dsNeYlR/HzhOGLSntV9S2UIXv+TFwaH5iOZCBryMTxy
vdWur2tZwjTncs3xaCcixQm3uWlfcxwCTJz/ZWt93UiKKfuv7sWEb4cg74D85Ez9
e/33cngT6IkBeb3AFXKYmlEcrPZ3+72gyUH2ewpYB35XS4DOj9u5++P76AJbSE2H
BYJGuik9g8Pi39iwbNDE2HxpTYc8pT+IZ2BjZIC3WxWL8Yq/pV7QO9qneVqSFlli
Lv6rvZH5LkUEsxpxFAfvVYpEDSD68r5yBeHI0Oh7zP5QW7+4VMCOXHRSNlMiO4YZ
O6wCIZT0gYnXdN2YRRLMUa9EBF6XA7CKMwPIC+iWvR+3MTDzaHrmeXW9KxgzNIce
yFT8pHLxiSpsVTk6U2DxzfRM61i7q8R4lH0xw5gV9KVs8xV4c5IFE4whmUBRlH8f
1WKgnECuwRm2gkY83spX8aez+19GOv3+CgoS+1PfZIOGXGI6C4GwDjNFuH2ox2Tz
Koir0oYSJYQ5b/E8WURb
=757T
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
