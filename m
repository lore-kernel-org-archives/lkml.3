Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3LTTzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:55:44 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59959 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab3LTTzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:55:41 -0500
Date: Fri, 20 Dec 2013 19:55:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20131220195509.GE31886@sirena.org.uk>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <201312091735.05014.arnd@arndb.de>
 <20131209165548.GE19163@arm.com>
 <201312091820.23006.arnd@arndb.de>
 <20131209180155.GG19163@arm.com>
 <20131216205133.GI5617@xora-haswell.xora.org.uk>
 <20131217112914.GB32118@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1+kiJ7gFzGEgD6MU"
Content-Disposition: inline
In-Reply-To: <20131217112914.GB32118@arm.com>
X-Cookie: Go climb a gravity well!
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


--1+kiJ7gFzGEgD6MU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 11:29:14AM +0000, Catalin Marinas wrote:

> - What if two hw vendors have different descriptors for the same device?

This one at least is already handled - ACPI ID tables are lists of IDs
just the same as everything else so we can have as many different
bindings for the same device as the hardware vendors see fit to bless us
with.

--1+kiJ7gFzGEgD6MU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJStKCaAAoJELSic+t+oim9WA4P+wU0BGGqG7eU29ZrTzbkAubF
38O1iUrG5oqhI6U6F5jgqV0+v1T1kNiUL9dVJuE4XAF8W4on8NS5wR/E5N+NDzk1
UlPpZ8GYMDK4JJkho6jZ0OJguvIiltG0SNuSQoMavL+IKgQ0nhow7hGMfnu2BnS4
g/1HYcZmRG3d9fjW6U7g4heUO3pv9J3+b47tWVlw3D1+wIjB8nfF6KzpowSqnOJ1
oTtTYrIfZ5tOiunsygQmeewDaM1ByrS3OFpevpXpgRnEvvzGb9jdVFvhZa81RopW
ufm6aH4at4UKbde2rGgT7qbvP2A4GejiV41EcHwyYcaLlBjHSXGSwLdZ4oj1oIyB
Vii1BY8r9a4Vzsc3Vpt8JSIdDqQ88wRa7uz/cJpF8V4XZiqPA5BCh/RKPiFReWw8
AJv72D9RnV4ttedpnLNydFxkv6Nql49CkA0WjlQRSpGpanI383dXBs8Cve98L03h
hbph2mczORG5S8RAYdvIJz2Mrmqws6h1SJw8vH0lvk+BKdE9sNgxzCuGlHHaDaKy
r747cV92v1gsqjmx93dMgsz0jieVeZqULuRIjbMY/qlU0tgoW+1b7nAuJLHBrkbC
mVDpXJoJcY8HF9qV1xUjDydiGXTxriW7FB1cae43OZDC5ONmM2gS76K+epRqgabx
pCOHc/qpEC9t/fLEKsoS
=ManL
-----END PGP SIGNATURE-----

--1+kiJ7gFzGEgD6MU--
