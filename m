Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3LJTWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:22:48 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41177 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3LJTWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:22:46 -0500
Date: Tue, 10 Dec 2013 19:22:17 +0000
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
Message-ID: <20131210192217.GI11468@sirena.org.uk>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <201312091735.05014.arnd@arndb.de>
 <20131209170617.GC30717@srcf.ucam.org>
 <201312100428.52588.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="STPqjqpCrtky8aYs"
Content-Disposition: inline
In-Reply-To: <201312100428.52588.arnd@arndb.de>
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


--STPqjqpCrtky8aYs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2013 at 04:28:52AM +0100, Arnd Bergmann wrote:
> On Monday 09 December 2013, Matthew Garrett wrote:

> > People are trying to deploy ACPI-based embedded x86, and most of the=20
> > ACPI/DT integration discussion seems to have been based on the idea tha=
t=20
> > this is a worthwhile thing to support. If we're not interested in doing=
=20
> > so then we should probably make that a whole kernel decision rather tha=
n=20
> > a per architecture one.

> Well, except it's not an architecture independent decision. An embedded
> x86 SoC will still be very much like a PC, just with a few things added
> in and some other bits left out, and you can already describe it mostly

It's not just the SoC, it's also the rest of the board.  The patches the
Intel guys are submitting at the minute are mainly for the off-SoC
devices at least as far as I noticed.  This'll impact anyone who ends up
using ACPI, we need to at least pay attention to what's going on there.

> with plain ACPI-5.0. Also, there are only a couple of different non-PC st=
yle
> devices that Intel is integrating into their SoCs, so we're talking
> about a few dozen device drivers here.

It's going to be way more than that for the whole system, and you can't
assume that all the system integrators are going to pay a blind bit of
notice to the reference designs.  Some will just clone them but others
will bin them and do their own thing.

--STPqjqpCrtky8aYs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSp2nlAAoJELSic+t+oim9kiUP/0P+O+z8QpfJzsFiOBAQtvtj
+/z7FJPJf1VMeDaNeu3Z+eqd3gnsBSDAVROBJq5tBJV+x4TiRqBjb0EtB+Rnlss9
KudNuP/+x/Fh6p6RJWGl4zWMN6L7b410UNzSLNyNYdUw0NYEykLFOKnTz9CEYMLW
YEpxWql4Liv66G/rauilsMnF4iwoYhx7w/BfV2xr/OB59XPsbAyVBJFlwAjw6M56
NTFg7z8iAq0xRRhZiKmCCv5SnCluqqpRvjNuZyj7z5VObgH03akJ4Pzd4r/9viQM
7AP/Qg12vUJaauOS17+1TRkS5w5j/eWX5or+RdBuPPiIhp5qJ3/gCcLXGzUAZnsC
NJnhKW2HGBQfboliWeRyMLgJ9Dm+pgRQdHCDpOD+K6GdUm3Q64n8CgviA91aB4Jq
1moEkFp+TwJ+ArQJ4j01ZgavqFwYizc+/wJ7aRggh1IfM5TCSlXE04C6ZICpMn3v
RbKYN6b+xRLX0XX2Mt8MnXXo2y57m6LcejPRlJj6mn2RXNEIZlLM9LVfwF/U6Np6
z3pZFnEzfnC/FAziyANq3YRBqV9mW4H1cQSsTmczmt4rx0mzMkOnoBuC2ua8J4Wi
y5AjlaLyZqU6l2TtWEND20y3pNmEyYZT7jNwxvWT7vpfOq4etFKm5T/FwBhFGwax
9Q3k/PjLAue/fMHpx/z1
=cosg
-----END PGP SIGNATURE-----

--STPqjqpCrtky8aYs--
