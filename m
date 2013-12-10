Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab3LJUXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:23:37 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51235 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3LJUXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:23:36 -0500
Date: Tue, 10 Dec 2013 20:23:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Mark Rutland <Mark.Rutland@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Hanjun Guo <hanjun.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Message-ID: <20131210202323.GJ11468@sirena.org.uk>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <201312100428.52588.arnd@arndb.de>
 <20131210192217.GI11468@sirena.org.uk>
 <201312102100.20570.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NqSa+Xr3J/G6Hhls"
Content-Disposition: inline
In-Reply-To: <201312102100.20570.arnd@arndb.de>
X-Cookie: If your bread is stale, make toast.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running
 without PCI on ARM64
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NqSa+Xr3J/G6Hhls
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2013 at 09:00:20PM +0100, Arnd Bergmann wrote:
> On Tuesday 10 December 2013, Mark Brown wrote:

> > It's not just the SoC, it's also the rest of the board.  The patches the
> > Intel guys are submitting at the minute are mainly for the off-SoC
> > devices at least as far as I noticed.  This'll impact anyone who ends up
> > using ACPI, we need to at least pay attention to what's going on there.

> Yes, but I'm not that worried about off-soc stuff, which tends to be
> off the much simpler variety: a few MMIO or PIO registers, IRQs,
> GPIOs or (with ACPI-5.0) devices on i2c and spi buses.

That's not my experience especially once you get into phone type
hardware - there's not much complexity difference when gluing things
into the system and the fact that it's connected by the board increases
the amount of flexibility that has to be coped with.  I don't see a
substantial difference between the two cases.  To be honest I'm a bit
concerned about what we're going to see given where ACPI's at as a spec.

--NqSa+Xr3J/G6Hhls
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSp3g3AAoJELSic+t+oim9xVkP/3MFSwNxegv8qEgzVXaHAlKR
obGpVqIbpI65FG9bFlTS7e8XiAjrz5fY+TjBSMcNqqtZgLZoZHHFtvdb+Vnhrdaw
XQq9/UdeHM9ZOdCsUtB3GOX2FJ8BSXypDIfcaIho/fhG9i4bitWEOcKcqpzfRuLc
ijWOTG2pRqFbWG2fWYWQp1PCdC2SCbnMRUS13zO8aBHxobvRAV3goFeWPyzE0Qgz
C+Pb4f25tWm/d6InNxS3Ty5MyXqBp/FIWNt+JpYDodEAB6/y7EJoL8KkMPKgdjf5
ffkd60uH7pb0owkCYA4fXMu1Q0GWwZk6BoYpZgNQpm4x0Skaf6GM9AOCGB/v8YVu
a7Kh0phVp3JGAtxXE1y2SyEXqwodhIaqXWHXLBC4F7X+ZY4aLA2ZTSfxnqvq0/V2
lNeOuhTLWRPa0moEUKPTHaGRzQ1khGTTjQYUCQceyXnecmRxqmS8ScEF8pcnQi1d
vwbDD9zZgxTmfIq7gx22sGfmbTXrLouI/QF7TdSJhpEEeR2P0xRuxc9IZi5zsHWj
q/2a32s4gOqVjdYYIL/ZydwVehgtnBGdVleVTqfmHVlECDwdOm1o/Ti87ENUN4iQ
UozZFXnJzTeIj07WaLurtQZhIwC+ay1PFDVYxbJYxayLjONRYu+4ZWpWKw7yWw2O
fZbJx6Ep5/80eehbNX62
=VUcH
-----END PGP SIGNATURE-----

--NqSa+Xr3J/G6Hhls--
