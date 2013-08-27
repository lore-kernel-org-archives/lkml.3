Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3H0VLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:11:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35979 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3H0VLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:11:13 -0400
Date: Tue, 27 Aug 2013 22:10:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Message-ID: <20130827211046.GE10783@sirena.org.uk>
References: <20130827153754.a28ce27a424e4cbeab503079@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oIK88BWnNPSddvdK"
Content-Disposition: inline
In-Reply-To: <20130827153754.a28ce27a424e4cbeab503079@canb.auug.org.au>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: manual merge of the regulator tree with the pm tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oIK88BWnNPSddvdK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2013 at 03:37:54PM +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> Today's linux-next merge of the regulator tree got a conflict in
> drivers/cpufreq/cpufreq-cpu0.c between commit f837a9b5ab05 ("cpufreq:
> cpufreq-cpu0: remove device tree parsing for cpu nodes") from the  tree
> and commit 7d748971c0c0 ("cpufreq: cpufreq-cpu0: Use
> devm_regulator_get_optional()") from the regulator tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

The resolution looks good to me.

--oIK88BWnNPSddvdK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSHRXSAAoJELSic+t+oim9nSYP/0rwFGkSPJ+uOAuqOyb0Zf0n
T9/vdS3RwCU9F1SYIB36u2YfUifud+zGAN/fh5AvWh/ZEFZl0wu82kuhL2SbIy7A
/SwuThuDTWg0z4Qj5fd1uE8qP1WYo3Bq2xvhpVitnV8comG4j7wj08OHEouZy1zJ
i7mZb999m3caBcTX8g3nW1Xo0+jp5zJmKWymwDq2WyFbjD8np9QqrCp9CTGSSFfN
WlR03OiJYIBCS9h+dMs+O8m2Qe54QiwgyyiKW7XJYwgLMAndfl47PLnBTDdIevhh
lkOjMGh6l3nGcsiZlAXcdia/af+u285s2bG8Sor1VS7vHfHJ3pRp5CoLtvH1eANL
mU6LvP64klCWPZzX3Roqre9zp47YZR4Gqa3zCDHjmuzn3InA9u6RPrasNQm2EP5d
hQ6xtreyCTqrA4B/A3Zui73Fxe4wnVGFULHKggRHJgBJOxKGwOgzS2PE38kQvIuy
oa3wgODqGzFU109BSO18HTkamnpSAZU4FSiEGrFa0gNP2rowbjlr4HyYOGLJFB+0
7dAzzaz3KOpUXONttIyBlsN0GEGzvlxuJJpH7nWGp0BXD+m7lzroceZh4FfVQfZf
1X93HkXlIrQmYxfBZWIw4ssQDULEp3neDtFNb7As0USlVmni1ruAxaH4WlEswY8N
vWMs0aUnIZj0mJRpvbDE
=WoZW
-----END PGP SIGNATURE-----

--oIK88BWnNPSddvdK--
