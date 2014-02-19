Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaBSN6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:58:19 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43955 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaBSN6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:58:15 -0500
Date: Wed, 19 Feb 2014 22:57:51 +0900
From: Mark Brown <broonie@kernel.org>
To: Etched Pixels <sales@etchedpixels.co.uk>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk
Message-ID: <20140219135751.GX2669@sirena.org.uk>
References: <20140213181559.GB30257@n2100.arm.linux.org.uk>
 <20140213182701.GA32578@kroah.com>
 <20140213184249.GC30257@n2100.arm.linux.org.uk>
 <20140213232606.GA27372@kroah.com>
 <20140214000717.GG30257@n2100.arm.linux.org.uk>
 <20140214001436.GA16287@kroah.com>
 <20140214003834.GH30257@n2100.arm.linux.org.uk>
 <20140217153518.30891455@alan.etchedpixels.co.uk>
 <20140217235013.GD2669@sirena.org.uk>
 <20140218100943.34f2e186@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7aQJ/pUO7E0NVzIB"
Content-Disposition: inline
In-Reply-To: <20140218100943.34f2e186@alan.etchedpixels.co.uk>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
 device probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7aQJ/pUO7E0NVzIB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 10:09:43AM +0000, Etched Pixels wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > It's a very real problem which affects actual kernels that distro style
> > users are building.

> Only because you persist in trying to keep the old static minor
> numbers even though they are not needed by anything in the real world
> that will ever run such kernels. Also only because you are apparently
> too slack to bother to check whether the driver matches the platform or
> there is an device tree node before registering it even though that's
> trivial to code and is already done by some other platforms and serial
> drivers just fine.

> It's a core code "problem" that is invented by refusing to do the simple
> trivial fixes in the ARM tree. Please clean up your own poop instead of
> trying to shovel it into the street.

Please try to avoid this sort of misdirected yelling, it's not helping
anything to complain that people are following the recommendations of
the maintainer or to demand that this somehow gets hacked around in
arch/ when we're trying to convince all the architectures to get their
drivers merged into subsystem trees so they're reviewed by the subsystem
maintainers.

If you have some examples of better practice for serial device
registration that you'd like to identify that'd be helpful, but what
you're doing here is making disparaging remarks and telling people to
adopt bad practices because someone else made a mistake a decade ago.
That is how problems like this get created in the first place.

> And the proposed change set is buggy as hell - because we register things
> like 8250 devices at least four ways on the same x86 machine all of which
> could in theory occur in parallel.

Then you need to convince Greg of that.  The most recent set of patches
are exactly what he asked for.

--7aQJ/pUO7E0NVzIB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBLhcAAoJELSic+t+oim9m1sP/3h8AGWjt6SRAJGq0YftYmCI
2FP4GjglrhURnXEXai2TRb7VQ8E3TKauIalcQkSfrgxVAcTAenT9T0vOOuH5MqLP
DMmuS+IHZXkfqTvq4aC1zCup/bZ6XdauJqS1dT+cKmybN8dA8TsASazD4xBpDHh2
29agoop6X7SjNDAWd2E4mXdusDuRw7dBbznDM7s+9B0XHFxQQ8mkElDLtgm7g8YZ
vrxo1BqsssE4fHXOsv0H9C874offG3xtHzIQF+5z+HZo2Ho7mL/uxvO0rYCbqdNC
kzgUr1+ZFkTS9lZTvAKDDbgsIM8mPv754DzKvqvCgl4ticFRA7dVs8woUaXEZF+W
YHYvlDJc0QXH6pHkzCzZI035ni5PHJla5XKh50lH5h/IXi4qGPWawKDvqVSUr1zI
aQwUPzwtIpa0a0t0VZvsZLT/htBUzzfu/YViXraR0eQ3BnfdMvG5ViRT5/RKiekh
be5Sla4UWKHJTEixPhwv4DP7YCrOaiFMwPYzePJS5uBDS4XvttmLBw2oNUogfNxM
7uQ06P883gMUOi1HHuQBkpgS0DWKWCP2knk1jGZDYPwoBf2gMGh3neWp0IN0NQvs
9bAq32ULro6btx8FOkMbV1ACUItyfc+Pr91pqVvCK+37d5n9klV0xESV8S878EeG
+a0WnYO2XYRbEJc0Vm06
=dC3o
-----END PGP SIGNATURE-----

--7aQJ/pUO7E0NVzIB--
