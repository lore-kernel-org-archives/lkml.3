Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab3IPKYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:24:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44277 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab3IPKYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:24:45 -0400
Date: Mon, 16 Sep 2013 11:23:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Ni <wni@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130916102337.GZ29403@sirena.org.uk>
References: <1378985061-28547-1-git-send-email-wni@nvidia.com>
 <1378985061-28547-4-git-send-email-wni@nvidia.com>
 <5231D709.5080308@wwwdotorg.org>
 <523688FB.2010701@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+EtoZOcuEljFWerI"
Content-Disposition: inline
In-Reply-To: <523688FB.2010701@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 3/3] Documentation: dt: hwmon: add OF document for LM90
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+EtoZOcuEljFWerI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 16, 2013 at 12:28:43PM +0800, Wei Ni wrote:
> On 09/12/2013 11:00 PM, Stephen Warren wrote:

> >> +- vcc-supply: vcc regulator for the supply voltage.
> >> +              If this is not set, assuming vcc is always powered.

> > I thought that was going to be a "Required Property".

> There may have many platforms without regulator, they always power on
> this device, so how can they set this "vcc-supply "property if we set it
> as "Required Property".
> Set to dummy-regulator? but it seems the regulator framework can't
> handle it yet.

To repeat once more: these platforms will physically have a regulator,
the device won't function without power and unfortunately the device
tree bindings only have optional and required properties.

--+EtoZOcuEljFWerI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNtwmAAoJELSic+t+oim9XukQAInDuT/CuiodQAxLwPHctc1o
1PDVDOD2tw2Y5raXf2BoiiFfIvOuQPjq85S2+rib0cO6CAGr9kNOn5TgYw+R3Cwx
+0wRkzs50kUjDrQGS1iMeFH3uRCiFRfajmyMaftUIQ8SPR5pmZHGnPc9CF0n19G0
C6QwNP/FpWbxRNaqTtiaFAPeSPYQjblCEknicV/R0o2kZoSqv6pWPBDqjfgX4t58
QPwAXd1yCscAnHXThz8OgUCxHCY+qeXtlU5WnqNp0TTCNsi1WOXXVn5bafJsDKPl
pwKxDFfvNDFZZnMGa2pOZANzWlJ4lsYP/74ghk52pTI86zjSpEBW5WUZ4yyoTdNR
/jN+i08Ml6gR4lqdFUimvX/UjEjoU6ndbkZ6pCXps9S/qfLCbU3k2o3BpwjeZ9D/
a93vVhPxDXIdnAHJNkgSlBJAr4HZ6fGH0l7Azzh5to6CCLmTSDsbulXXYOkEY8MM
EDqMg8osQXHCOcE1hVt73rXGp3FDWRJ5oBbY8sHomIw7TGJe0bBbXRtKlWJrOO6d
Q6SUCXJuxcOSr23EBKJy0i6SkzSvzWFd0n2tYzhDnOrtgoezY6JwjAgodYfPKaZ3
+m62n01rsy8u4M9WrcDHyE4KDgGXd75AvUx3AexY8sctunSfjAsl7uxdK0WgbtNh
t+LVAd8OQdxQ4HTgZqTl
=aUd3
-----END PGP SIGNATURE-----

--+EtoZOcuEljFWerI--
