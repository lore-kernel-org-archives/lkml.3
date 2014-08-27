Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbaH0MA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:00:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35929 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaH0MA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:00:56 -0400
Date: Wed, 27 Aug 2014 13:00:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>
Message-ID: <20140827120051.GC17528@sirena.org.uk>
References: <1409061793-10495-1-git-send-email-jarkko.nikula@linux.intel.com>
 <1409061793-10495-3-git-send-email-jarkko.nikula@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I5Ma3wx0KCNkqmhb"
Content-Disposition: inline
In-Reply-To: <1409061793-10495-3-git-send-email-jarkko.nikula@linux.intel.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: rt5640: Do not allow regmap to use bulk
 read-write operations
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I5Ma3wx0KCNkqmhb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 26, 2014 at 05:03:13PM +0300, Jarkko Nikula wrote:
> Debugging showed Realtek RT5642 doesn't support autoincrementing writes so
> driver should set the use_single_rw flag for regmap.

Applied, thanks.

--I5Ma3wx0KCNkqmhb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/chvAAoJELSic+t+oim922oP/RoJUJ4VSgOPawQdiSoN8cDX
NQa1/3oxpN72UpRilO+WVAxBnmiTIX88a79Bilvv3X0o6KxzIsydspKeo+eIWrgM
tJa9RUMGumRB+yXNlbcEh9hr+eAJNXU+rCybp77iruWwMhKw8MRCUmpDubxZ7lV/
qfcjpKEkYQvJLrqHY4Q2CO6TTw8lKYz2Am7NmrsshSWoyrPzr3YT/z8JlifwDi03
7+k/ztJP9RK/LFoXjv1dfKgGa/szhNxnD+yXtL+PQ7FYkh7OeJRL8bWH8Y0ZE+vO
jAj3JYy39EuxW7/aod3AZunFtk1i4u1AcVfGSW8U4q9OXUCjvQgqT/S83kz0HMTo
fmFLH89Rg/Q5JdALnx8WCLvVwYz17UT6p/Ogg3H0A4/MOWPYD3nNettPKOmvgtCE
+0onjkq9sSw5GHgaIN3Ya00gG7a0krp0BplMLbYiR0p/eZ+Nlw57NVK0px5wSTy/
tqeawdREhoexGJ86/k0XX7R4t7zGGk7HF79vfqSqzc2JuGNVP2HuRZ4N5xfMUyp5
Pu9mHqMNf43rLMO8PcQoBVYHu7IJLxV/474+hG/6r/oA4sgmuPpH/eamjSRIMCgq
20TbBXoMtfuk33ahEO43IspHsqLQ4NEhiJ4gUrc19Mv9UGdjV4/gAAvGesIyq/lE
lsdHThIgh1c3qOh+GHvb
=4Cg9
-----END PGP SIGNATURE-----

--I5Ma3wx0KCNkqmhb--
