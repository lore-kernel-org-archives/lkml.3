Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbbA2Bdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:33:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38404 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbbA2BZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:48 -0500
Date: Wed, 28 Jan 2015 17:39:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20150128173954.GC21293@sirena.org.uk>
References: <1422391108-9011-1-git-send-email-andrew.jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="HxY/eTLWEtH+OqMc"
Content-Disposition: inline
In-Reply-To: <1422391108-9011-1-git-send-email-andrew.jackson@arm.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH PING] ASoC: dwc: Remove unnecessary conditional
 compilation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HxY/eTLWEtH+OqMc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2015 at 08:38:28PM +0000, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
>=20
> of_match_ptr is already conditionally compiled based on

Applied, thanks.

--HxY/eTLWEtH+OqMc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyR7pAAoJECTWi3JdVIfQMvsH/1ug1zYiuWFcNDLdhDyYuwu0
1sCdCBvkQHtMvzxAWf99dGOecmIDMvbLXy5b9/mPBGyj1hROJDWjH5QbQuA3DXWI
HiLbCRE4iDZbSHla86QwzmJ11dNvyRFrMjExPr+5jXKXreuonukrrqCkhcQGi9Nw
D2w1tNxnoUS2+NLPoEnWzabv8vgJyVZRIS8SpgiQW0r3MqX2CQog4/HISGWQAO0T
cXkpohqR1CeLs0qXmLMF+Zv21aAXqu/BF2alTYKxPGEe4i9SlDsFZaYqGCyY12J0
sOc40Uq4UYI/RZUBYImkEjVsy7gCQeXj/4zj2Pj28eBqGrcSZw8+2sic/hEduGs=
=U0xS
-----END PGP SIGNATURE-----

--HxY/eTLWEtH+OqMc--
