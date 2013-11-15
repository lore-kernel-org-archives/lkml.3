Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3KOO3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:29:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52045 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3KOO3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:29:24 -0500
Date: Fri, 15 Nov 2013 14:29:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20131115142919.GK26614@sirena.org.uk>
References: <1384523303-25943-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384523303-25943-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZkK3DH7HIvxYLwhR"
Content-Disposition: inline
In-Reply-To: <1384523303-25943-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.56.239
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] regulator: arizona-micsupp: Correct wm5110
 voltage selection
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZkK3DH7HIvxYLwhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 15, 2013 at 01:48:23PM +0000, Charles Keepax wrote:
> wm5110 provides different voltage configurations than the other Arizona
> parts, this patch adds support for this into the regulator driver. Also
> fixup the default for the configuration register for wm5110.

Applied, thanks.

--ZkK3DH7HIvxYLwhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJShi+8AAoJELSic+t+oim9sN0P/RnOorPZYq7D9RNe8ouWVO6y
PiufwA0qb0IQgR3+WZoruL3J23TLS3mrAxDWiW3liljIdaLp01qpTG9p9L69hUzn
vUGDVDC+eN7fQ7QXYyOIQNo1hV+O1K6nzD4TXjWO3ye6jJfU0fU/ER3xr3AP07TU
UDrs1JNKRehVwju0+zC3BtEv2st0BM3PIYYaTroPa3D3/JWP1Z7DbS5UKXqMNntZ
0AwV/V7EvI74sBEGeokd0huPZS8SKtDaYygyc70S9owxk/HrAN0cjUiBjikN8MEi
KodmFNDpiTkOjdM4AKIphGMvEx9fI+Kavp3W1FfpFvSH5dXyx+JkjK144/xdIKkp
KWO/FoTs8nOmYMOqvC+e1Odd8oIe4eC0WygVu486w2/L4QErJgKKEOHJ3dtY1KkT
u5EB2MfdUOK4CIDf5QNWgsfXW436tZb5HLX7Sh6rrEj2hlZdR+4eTHyH6AbvaD4v
MB4Yone1FNxRtNpKMqzgmaTYCLv9nH1dU04VaLuN5DkD9m5hi1h/p40TpxLDYUr/
NVvObUuDkVrWEveWNk6U8WWd5a1tYKxyEqKM6GAFSAqNROwoUdYq5Rv7nsZKxs3I
T/HwdrW97LhXfVobrlbyzu/5PWeC/967WEMeDwOGeZ3TdInZjE7uw3CnKdR44Itd
cOJIfRztyN/Ki2Eklh2p
=BYvw
-----END PGP SIGNATURE-----

--ZkK3DH7HIvxYLwhR--
