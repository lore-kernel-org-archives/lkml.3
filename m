Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaBDSM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:12:27 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35390 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaBDSMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:12:22 -0500
Date: Tue, 4 Feb 2014 18:12:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20140204181213.GO22609@sirena.org.uk>
References: <cover.1391274627.git.moinejf@free.fr>
 <8e4231b7a55802f58a14dd07ac5cd8b0babb1dce.1391274628.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e59cmCxsGlzMyaN0"
Content-Disposition: inline
In-Reply-To: <8e4231b7a55802f58a14dd07ac5cd8b0babb1dce.1391274628.git.moinejf@free.fr>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/5] ASoC: tda998x: add DT documentation of the
 tda998x CODEC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e59cmCxsGlzMyaN0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 01, 2014 at 05:48:49PM +0100, Jean-Francois Moine wrote:

> +	- compatible: must be "nxp,tda998x-codec".

It's not clear to me why there's a separate compatible here - as far as
I can see this can only appear as part of one of these devices and
there's no addressing or other information that'd account for chip
variation so I'd not expect to need to bind this independently of the
parent.

--e59cmCxsGlzMyaN0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8S16AAoJELSic+t+oim9eOIP/AyusIviYZa8U00UwCEjbhBb
O32EjirGkgP7RFqbsaVN6u3nudovMhGrwEs7AGX/gB0Y37YA92bJVj4k3PkmrEiV
e9qFEEgQSSfTsrZ0c6vb/QdgRkdlKFl5WD8YX8JzhocociiRyok0mFJBVCESGbkv
cRWnlWTR1S0WPoQj/KCeky/Mqjfn2x9KK1GaKnSEb9QfxXLvaLfpFmsF3ufWhkr4
y/LQ20xPO6YgpgUUxe44OeK2G3YfUDTw0biMjMJrL9x4GyUv0dnSkQhP8dntG4iu
mn+xu6y7u1vBTcB41+FrbsdZAYIsOV4iK93ynjQOMSPtb+fj+ukg5BuYxyz1fkPR
p62RBBz9DfdINtXwQdiYDMTSgEl9Da7r/6vs+RNsaVrgSWThm/qHY6kDpukP/r3y
68pxxXhzExxSN8srmWniMY1nKAx046SK6NJ0YRfs9pnjelYu5m7u67KMgJysbcBz
1Wcd0Yva2aaGfkzcikeEFmASDZxgX0Alh5GzSJ5MLqjatGFF7QBG6ReHLUMMjWlk
Ydw70uDkSbpKsJHE3pO5FNDj9+bd12wM92HP5t1w1hpzvR53PZGBknOVWzevRL8L
NA9aTEZ3Est7UnfwqVHW/xIRuqUClHn0cnYzfnlldGmEoD2Rpo9SKMxx7zxQwpUc
asguWWttm5sdpHL5eHxZ
=AI7n
-----END PGP SIGNATURE-----

--e59cmCxsGlzMyaN0--
