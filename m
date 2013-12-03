Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3LCR71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:59:27 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50411 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab3LCR7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:59:25 -0500
Date: Tue, 3 Dec 2013 17:59:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linaro-kernel@lists.linaro.org,
        Graeme Gregory <graeme.gregory@linaro.org>, patches@linaro.org,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20131203175908.GH27568@sirena.org.uk>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <1386088611-2801-3-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pn37QocMfltEWxia"
Content-Disposition: inline
In-Reply-To: <1386088611-2801-3-git-send-email-hanjun.guo@linaro.org>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC part1 PATCH 2/7] ARM64 : Add dummy asm/cpu.h
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pn37QocMfltEWxia
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 04, 2013 at 12:36:46AM +0800, Hanjun Guo wrote:
> ACPI requires a cpu.h, add a dummy one copied from arm. This will need
> updated or replaced as ACPI based cpu hotplug for armv8 is worked out.

We're going to need the same thing for CPU topology, I've got a similar
addition as part of a series to introduce that (which is going to want
an ACPI back end at some point I guess) at which point it'll stop being
a dummy.  I should be posting this week all being well.

--pn37QocMfltEWxia
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnhvpAAoJELSic+t+oim9XrwP/27B9eW5D6QqKsmBzm5lQmm9
H18D4MTDoFBz1xzNA5nU4vNZN+MUQ7dHL1Kbk9RETceGt9BBCV/hhJvv52vJNZnJ
Dc4lC4I5Gb31fleohVehC3hK2yDzm3/m9+PyAf1N3jr9mftmJzpwh7p+XjvZujmq
DQSElx/GWNTbLEBjXKQhfjP1Z0AlD7VgDI4kxY3VAc7oymurfCOCvcJUESBYoukx
SCF4cxESaMVsSCLXHCaN478bf6xwapnAO7pv2vmy6q6UzVl0900UlHxrDoxPixZy
ynzrknTyQSuc3uMEeN5w+vEP8Shkja3jLnnRX49VDmL4kPFx3Hz/94s6ZRgvlK+C
qnRhuaSrBR1Cuo5j/M5QgoCRT+oDHRMoru+4u9gqDjCU37C1GG48glCPU4fEAViO
ktdVOLbSIo5e3tp61K22z7ObVi32fqop7yzQem4yaYUherbp2cO51LeYXZpLLC8f
E6eqUl3Z9nLpjM9ipyp/CaEKv2geAV9u6O0DjwCNycH6QfEf44XieikQSIZ/cH9X
ew7VM+HYORICYH1pCMiA/HYqt5b+dPQ+NOVSeGzb5aK7/y7+6g72vjXZC65C0Krq
KcG/hKB98XJvXy4dLO8H8C+uXE3qw3OzAQiAW7OAJha1GDn+d3fs4WOg/HQZW01d
m1XYhz/WN173z4vfw8cN
=U12+
-----END PGP SIGNATURE-----

--pn37QocMfltEWxia--
