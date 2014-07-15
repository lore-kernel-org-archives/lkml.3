Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbaGOWx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:53:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39292 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886AbaGOWxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:53:20 -0400
Date: Tue, 15 Jul 2014 23:52:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
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
Message-ID: <20140715225252.GD17528@sirena.org.uk>
References: <1405028569-14253-2-git-send-email-ttynkkynen@nvidia.com>
 <CAL1qeaFF0ZpUFovxTuLXrBPRg2Lbf-754Z=ztD5HFZPbfnDsAw@mail.gmail.com>
 <53C01558.3090607@nvidia.com>
 <CAL1qeaHETQ7kSGNjPiwi_9WNMtr9qZp0KwjZCCxY29+_N4AcuA@mail.gmail.com>
 <53C01D17.2050906@nvidia.com>
 <20140714083854.GO2081@ulmo>
 <20140714091233.GC6800@sirena.org.uk>
 <20140714092434.GA9755@ulmo>
 <20140714102203.GD6800@sirena.org.uk>
 <53C58DCB.90502@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/unnNtmY43mpUSKx"
Content-Disposition: inline
In-Reply-To: <53C58DCB.90502@nvidia.com>
X-Cookie: 98% lean.
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


--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2014 at 11:23:39PM +0300, Tuomas Tynkkynen wrote:

> That sounds indeed useful for this case. How'd the following interface
> sound for the register offset / selector-to-register-value conversion?
> The I2C address would be a bit trickier to get as it would touch the
> regmap stuff as well, but perhaps it would be a good idea to have a
> phandle to the I2C device itself, and then parse the reg field for
> the address.

This looks fine, can you submit properly please?  For the I2C address
why not just have an interface to get the regmap and then provide a way
to get the underlying device back from the regmap?

--/unnNtmY43mpUSKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxbC7AAoJELSic+t+oim94DsP/3hee0clNxB4r6hBhDawbuBR
ioR6YThPt82r79ST9ZKqgpkwcmGGjZura4HxaMb/ViPJJCsck3V0HgfJATp4/quC
qyBxYT4v/OhZTT/GWld1YB3uk6HG+P5nXqgBBFi1NJbnueXvHFwotRjpMepsRR3p
JSLZOCQ3AYztf6SZkfwiaysIi/n93MEMMNKz2uH9dSQjbE8dyVF2qPy+lxtchwMy
sj2ndUslH9GBaJC4jZcHVWr236SGTguZiPpukgNVNYWTp6g70Vpl0SmRZcIIH5xT
ksQnAiwoxrgAlWdFLFTGHUAW67HWcVi02QJh01wEyFI3fHiu0pF1/74V2WSRK2Vx
deMW3eC9FuqvENsJ5sfGaDkvCTduNsYehiWpoPl5QMJEtWgA314Foscg841NxTr9
QzXoT1DvfHkKVOew+pgXsWhYzg0aazZq+GpxTabcuvQZ+60Zf6tnSyE/u3zCMcfl
UD9DjqaRbt9ZoJfhRC15VsI+eEiUOI2SMN2ZvvoU/IPIk/Ed3gPVj1t/m+5ZHXXc
A4tZAc7tK1UO2JS15fVvEmWpqv8lxK29xT8Y+fNrixwdBmwhBgsRdQnJjc9liJbV
r7p6wBWbw5DEQwt8o+5Hy+kj0G2Z5t5PKWXA5q9Je3wOkhTFqWvMz97Q0NqE9A5b
MsZQFoed22IyuNUuDhtW
=RoQC
-----END PGP SIGNATURE-----

--/unnNtmY43mpUSKx--
