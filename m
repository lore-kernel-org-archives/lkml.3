Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaLSLlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:41:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36572 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaLSLlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:41:17 -0500
Date: Fri, 19 Dec 2014 11:41:07 +0000
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Message-ID: <20141219114107.GE11764@sirena.org.uk>
References: <472992175.g1ArEYGFPo@vostro.rjw.lan>
 <26780431.Uk4uOmhdgG@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q3FMjjSoRTBgph49"
Content-Disposition: inline
In-Reply-To: <26780431.Uk4uOmhdgG@vostro.rjw.lan>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] sound: sst-haswell-pcm: Replace CONFIG_PM_RUNTIME
 with CONFIG_PM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q3FMjjSoRTBgph49
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2014 at 02:51:38AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>=20
> The sst-haswell-pcm driver is a new user of CONFIG_PM_RUNTIME.
>=20
> However, after commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) PM_RUNTIME is always set if PM is set, so
> #ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
> depend on CONFIG_PM.

If you're going to apply this please fix the subject line to use the
style appropriate for the subsystem (ASoC:).  With that...

Acked-by: Mark Brown <broonie@kernel.org>

--q3FMjjSoRTBgph49
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUlA7TAAoJECTWi3JdVIfQaVYH/0UURPiVWx6MO9Vwys/SVoLQ
JsQ16hGHq11REGaIvcl8U6ti27QAtJzuAtAdP5jMLiJ0FK0uIKx44AaLj87fZKGT
AvCeSlHa7B62tTWvnilaw4tKmh51SSiUs3c4STfb5uw5GhnMvlRJGAk29zAJ3TXH
dYEsIYkEbcX4czSEa1npJogunCMKflFZ/TlsiMOWCdUjB8SugSxXXsiRiCYCYX40
MQygzHtE4hIn7gaabYllV53hk3NudZwdE25yytJuvI29ikoi2X5bppDt+dyWreqf
6vCxFgYuH8NgJNKZey4Xek5FBwGY/fgtFjdU3wx03bbk2r3JZq1qJc8+5PxqGgc=
=HOPq
-----END PGP SIGNATURE-----

--q3FMjjSoRTBgph49--
