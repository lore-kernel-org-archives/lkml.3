Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3LENY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:24:58 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43695 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3LENYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:24:54 -0500
Date: Thu, 5 Dec 2013 13:24:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linaro Patches <patches@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20131205132441.GR29268@sirena.org.uk>
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
 <1386088753-2850-3-git-send-email-hanjun.guo@linaro.org>
 <CAL_JsqKF-_GCRR1d5Hs0F6pCMfLxUYkXAAp9hY7Ywuu1C+aZ0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W1G4cAX3lNqeBRc9"
Content-Disposition: inline
In-Reply-To: <CAL_JsqKF-_GCRR1d5Hs0F6pCMfLxUYkXAAp9hY7Ywuu1C+aZ0A@mail.gmail.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC part2 PATCH 2/9] ARM64 / ACPI: Prefill cpu possible/present
 maps and map logical cpu id to APIC id
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W1G4cAX3lNqeBRc9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 04, 2013 at 09:47:49AM -0600, Rob Herring wrote:
> On Tue, Dec 3, 2013 at 10:39 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:

> > +#ifndef CONFIG_ACPI
> >                 set_cpu_present(cpu, true);
> > +#endif

> Should this be moved to DT cpu topology related code?

Part of the trick there being that there isn't any CPU topology code for
ARMv8 in mainline yet, DT or otherwise - I'm working with some patches
for doing that with DT which I'm hoping to get out soon.

--W1G4cAX3lNqeBRc9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSoH6WAAoJELSic+t+oim9nJsP/jc9176AkYvZDjck2LzwXX1Y
qNrW1L8s5tTBF6DI0Gnmjlui/DOItNWlNr635pV/HsB1UVBVpZyeALEPYS4um7Rn
DYrTxwKIxUJgAXDI6htD9uDIxN8D/f4xz3FhiGub+x5sqbTk1u/bA7NAQzGXM4B0
rrzC3XBpb3q+/SXyNNBsKxl3Ywc5YbhRUo2BSRH+5wFS1vrzkpLyEpwV/AF5V2GS
Wrxgpaxc5OOBj4JYy41Vv3N0Uwa6wCRbY/uo/V3Hb4O+WR9g1n6+XhEj7v9UzJFX
RiWAdUEcCp9vmMIJFtC3NOdbPxXr5lxS8HksVu7kcX7X8EFbPOsKKKQt2JZn/rsu
CIXJM/nvAtj4Amr48zMuYnOwyd5d5Vk8Hcjic2i5qF2Ep2Z6iwtVHGqXoqaD4D+8
xvmYzKSZp0MSGHM6vkEIhiPXL+da8YWeY4PEBPDEYI9GUcEasYWpCKNUsFuuomtS
Tc2SsmcEphVdhrJR/Pv2giDovLZBU4T+SG6gnLfSY9xi8CtbjfdGyg+9WioqatVY
tYWOa8zqbHDnid+pn5DOt+NJITZbg/ksgf9AQESUrt5Hi4Q+lRbfXCwwAaYhKxhk
xFcgVusClPkLvyLyC3rcQL41ywZlZjNv7v0sVGcNEd9rOoefcxmf0T9EP3neobu3
EJuzqaL01O1QOGfsaswf
=9uVy
-----END PGP SIGNATURE-----

--W1G4cAX3lNqeBRc9--
