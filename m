Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaE1RiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:38:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45769 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaE1RiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:38:15 -0400
Date: Wed, 28 May 2014 18:37:55 +0100
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com, edubezval@gmail.com, pavel@ucw.cz,
        lgirdwood@gmail.com
Message-ID: <20140528173755.GF5099@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
 <20140527192923.GC12304@sirena.org.uk>
 <233568355.QJI3TVGr1I@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hUH5gZbnpyIv7Mn4"
Content-Disposition: inline
In-Reply-To: <233568355.QJI3TVGr1I@vostro.rjw.lan>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hUH5gZbnpyIv7Mn4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 28, 2014 at 01:12:57AM +0200, Rafael J. Wysocki wrote:
> On Tuesday, May 27, 2014 08:29:23 PM Mark Brown wrote:
> > On Tue, May 27, 2014 at 05:37:29PM +0530, Viresh Kumar wrote:

> > > Liam/Broonie: Please see if this can go through Rafael as 2nd patch is dependent
> > > on it.

> > Is that likely to happen before the merge window?

> Depending.  If there's -rc8, then maybe.  Otherwise, nope.

The reason I was asking was that I'm happy to just go ahead and apply
the patch right now if you're likely to not apply the second patch until
after the merge window.  Let's just do that for now, if you decide you
will apply then please add my ack and let me know so I can drop the
duplicate.

--hUH5gZbnpyIv7Mn4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThh7wAAoJELSic+t+oim9tJEP/1FknClrkL3Rskx0DVOBA+mq
3HQ8Fpsv8sNjZ8eVhTi+6ajaoVIDLp27zRYxMAUlF64OdlPzTdjKmj/rOR9crsQq
bCjkLDFzxeBFA+xC6VMFX6ipumEy8qelCpKV8W4FiSy8kVNzyGVMxEZ3GT/MCBC8
/g5LqvHXlv7EK7Aens+/GUCqm+HEcS/Hbh/XktlfLUNIlP6khJ9rrTeYVqeBirBe
PLCHuv4q3an7rm0Yz2HV8ACl1ICWEjQVFvd13HgWe9nUUfsFJDbT+9gdJhTvYGIU
dpsbc7qDrmNtl8WXJq9p8pBFwMlKbQ7wwJdsZd0j6896CL9ODMk19fsxGsPVbvDv
ZvYOm+eTifmVfPtAQZl/MRIYWTh/1/od/UYMvCeH2v/meQYuu1HjZPMC8pbjJdON
dXC+2qbwDq2udN5ghRP1PXjC96sKyYkUa+FxwXepwDGcDSHbewA5scROysqzygTT
FeIfKemEuqZaHCKBNlGyKw4s7XdIs2nK8L1gqJyAzweXopNbgkd/U0VZOM9x7xPq
l642KzC7Ec0Ls0umqiGlY4mGA7oWxgJrFa0txiDG/kTncZosuueBuGbCadvW3/cf
HzXH/Au24NfuOX6fdGZeuxiwfbEk9mbNpw2iTnPEpIVCC8lnGB2J5HU+s3RVWuiW
rFQiDfWlohbaDcxUBRJt
=durA
-----END PGP SIGNATURE-----

--hUH5gZbnpyIv7Mn4--
