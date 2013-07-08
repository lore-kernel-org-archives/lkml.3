Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab3GHNTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:19:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51524 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3GHNTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:19:12 -0400
Date: Mon, 8 Jul 2013 14:19:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, sbkim73@samsung.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, sachin.kamat@linaro.org,
        yadi.brar01@gmail.com
Message-ID: <20130708131900.GA27646@sirena.org.uk>
References: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
 <1372510280-31931-2-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eWAQXdaW/6bU2HH2"
Content-Disposition: inline
In-Reply-To: <1372510280-31931-2-git-send-email-yadi.brar@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [v2 PATCH 1/6] regulator: core: Add support for disabling ramp
 delay
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eWAQXdaW/6bU2HH2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 29, 2013 at 06:21:15PM +0530, Yadwinder Singh Brar wrote:
> Some hardwares support disabling ramp delay, so adding ramp_disable flag to
> constraints. It will be used to figure out whether ramp_delay in constraints
> is explicitly set to zero or its unintialized (zero by default).
> And we don't need to call set_voltage_time_sel() for regulators for whom ramp
> delay is disabled in constraints.

Applied, thanks.  I've applied this on a branch topic/ramp but please
ask for a tag if it needs to be merged elsewhere - I'll definitely be
rebasing after -rc1 if nothing else.

--eWAQXdaW/6bU2HH2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2rw7AAoJELSic+t+oim9FTQP/Ay/CHLL1EKoEiZggrAywbV9
dwcqNMw3K6rFt7aTjApIteasrRSHt3VVZQbEDaL+WcfTW9ZZX46qLQAXpyJErrpR
2Gnbjk61ypnO+CZ53xHbayVRIJVop14oIhHM/JpKLZP3iWowB6YaHOO2dAcy3JkA
hQB89P1w8ReX35hZiAPZLwX5UpLqn72awlRe+eY96+LhR2VRVugR1I72r4ZbIsJL
C6+wsLOSfco05MqEiY3wROV08t5mc2b8W+W8me+jOBgnb0VAGHbWAqSdpWh2OJWA
6BJnEKbLZL/LEJ0jrcgTaQCSboNb6cEtqAhuzS2M0lkbF4Tb4ddRlFpOHRydUOQK
2uCFoBog0vnm/T10HJZo0InQ2RC8OW2ZnNMGyLzCDih9p+AuOyo6NHZ4SLjoSALc
m0afrNVEeYz6YLz6AcVW8hkYc+DDh0+0QIENvjpNnkcrNVzqYdnYtIiZqPE4n+QI
G834t9iPeb/Jb+6E2h4evGnSQ19F1IubAzfgg1iEiTzxNtNfeXduiNtPzmw2iK8D
o1cD9ZuGpwqpB8atb8jVO0ydXOJwcsKbVAeMzr097qSymvak96/5Rolut2/edAvI
b+FxWpktjrF5Hm7td+cw1MJVQthiuKY6egJNKXH+cviG1wRXN1mPINb0zwPe9GCz
CfQtax8Agj9+Qgq2qHKU
=SSJq
-----END PGP SIGNATURE-----

--eWAQXdaW/6bU2HH2--
