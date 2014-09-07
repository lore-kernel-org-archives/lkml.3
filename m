Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaIGPFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 11:05:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55310 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaIGPFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 11:05:02 -0400
Date: Sun, 7 Sep 2014 16:04:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140907150429.GL2601@sirena.org.uk>
References: <1410086091.4121.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eWbcAUUbgrfSEG1c"
Content-Disposition: inline
In-Reply-To: <1410086091.4121.1.camel@phoenix>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.177.228.237
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: as3711: Remove unused fields from
 as3711_regulator_info and as3711_regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eWbcAUUbgrfSEG1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 07, 2014 at 06:34:51PM +0800, Axel Lin wrote:
> The max_uV is not used, so remove it from struct as3711_regulator_info.
> Current code is using devm_regulator_register(), so we don't need to store *rdev
> in struct as3711_regulator for clean up.

> Also clean up AS3711_REG macro to remove _vshift, _min_uV and _max_uV arguments.
> _vshift is always 0, so remove it.
> _min_uV and _max_uV are not required, all required settings are set in
> REGULATOR_LINEAR_RANGE macro.

Applied, but these should really be separate patches.

--eWbcAUUbgrfSEG1c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUDHP8AAoJECTWi3JdVIfQjdAH/RsJRzyK+MeqSmHp0BlCHZie
srHQpLLUwVC63IwwGaN0xqkKC8Gr9c9wqPAtxoUmN/CuiTG2Ddmo7gNcI5ZKW/Me
WXIjmLX9qz3ZOw59k4vhD/Mf57xY3sMBhfxUq4RfEpETmH3tzT0/p5TfR4Zzp9TZ
sVHJHH56qAsmKpwr8voDb9L8Ig1I+TMeHCq0hRTa198Sy5ERnkXykkJV2Gf6BHNt
pv9XH6J3/CEZnwQrJoCvJ8qaatYtkCTBOt2jjzFp/o33Z2gu503nEuhMNbx14pK/
KXut/MOkmgCxU5YU58ahjroY2o6DSfm+nNMRMnS7hib3wO8bS6PINxi8e3PzG+A=
=qiB/
-----END PGP SIGNATURE-----

--eWbcAUUbgrfSEG1c--
