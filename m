Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaGNJNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:13:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36664 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaGNJNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:13:20 -0400
Date: Mon, 14 Jul 2014 10:12:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Message-ID: <20140714091233.GC6800@sirena.org.uk>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
 <1405028569-14253-2-git-send-email-ttynkkynen@nvidia.com>
 <CAL1qeaFF0ZpUFovxTuLXrBPRg2Lbf-754Z=ztD5HFZPbfnDsAw@mail.gmail.com>
 <53C01558.3090607@nvidia.com>
 <CAL1qeaHETQ7kSGNjPiwi_9WNMtr9qZp0KwjZCCxY29+_N4AcuA@mail.gmail.com>
 <53C01D17.2050906@nvidia.com>
 <20140714083854.GO2081@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Content-Disposition: inline
In-Reply-To: <20140714083854.GO2081@ulmo>
X-Cookie: Above all else -- sky.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/13] clk: tegra: Add binding for the Tegra124 DFLL
 clocksource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 14, 2014 at 10:38:56AM +0200, Thierry Reding wrote:
> On Fri, Jul 11, 2014 at 08:21:27PM +0300, Tuomas Tynkkynen wrote:

> > I don't think we can assume that each selector maps to a concrete register
> > value, though I'm not sure. include/linux/regulator/driver.h documents for
> > @list_voltage "Selectors range from zero to one less
> > regulator_desc.n_voltages." but maybe the consumer API could take different
> > values.

> I don't think the regulator API makes any guarantees that the selector
> corresponds to a register value. Adding Mark Brown, maybe he can help
> figure out the best way to do this.

The selector value is opaque, it's entirely up to the driver to define
it.  If you could tell me what "this" is I might be able to advise on
how to do it.

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw57+AAoJELSic+t+oim9AGsP/RZe8JPihANdv/oeybcpori8
i2DpTFTqDeqbjE6YqHLCjBuQdHAwr+liAFnYyuaYOy1mIymqufXZw+oiUX9jNraW
LOXJuq8pU1z+nJvjBgQVNsy8t6lScak1IpLYmA8N2wpL2AMtlBqnKCyxs1OZloYF
3TXHwfPGZ9cQrONrYAHSEEpX+xkBZ0NSc9VaCwwEC+DR9jc8ODXj/bJkBp9JXrZm
jHLGl4p5H8IvIKQSxp1iFc/lDkNgobzTEV/I+n2NksyVRqYRZaHlMOzzzT6u/jyf
8bJqjFe0gg982lBs8j07yWG6hgralBiC98nvlS1zunuXepM0Nge9IO6gsycd31qJ
CD0RabiwRSlJGlliSiePNNDDH7pzO8bDq1NuG2SijnZq2YvP2kN2z6xu4x8q+YpJ
h/c2i3/Y5rBeliT5LcukoIKicc6QAuKP2lZUWA2aZWcGHgUDHhivE6ibjkaFwco5
GQSZ63psaIbJINtVKeWbkFtswwGeGxPdgK5I3qEcoRnEfn/Aala4XmorgpV90seL
OnrWFOdjZuTDYHmr3SKoRs48u74Bt4Ce2Fq1rAgeltXfiRff1exiwYcoupUx9pkQ
INA/P9TAguSJBy0hj4/zBMtZObsp9T/T89gliTf8v/yBo5+N9l4xQNJakq9muS4P
jBg4x2lRrdNC/7a/Qpn9
=oEVi
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
