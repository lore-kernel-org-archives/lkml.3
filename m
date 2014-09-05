Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaIEKfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:35:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51399 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344AbaIEKfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:35:12 -0400
Date: Fri, 5 Sep 2014 11:34:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: James Ban <james.ban.opensource@diasemi.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140905103449.GD29327@sirena.org.uk>
References: <1409879575.5208.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wpxcqqTuihheY91T"
Content-Disposition: inline
In-Reply-To: <1409879575.5208.1.camel@phoenix>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: da9211: Set of_match_table and export device
 table
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wpxcqqTuihheY91T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 05, 2014 at 09:12:55AM +0800, Axel Lin wrote:
> Also move da9211_i2c_id and da9211_dt_ids close to the user for better
> readability.

Applied, thanks.

--wpxcqqTuihheY91T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUCZHGAAoJELSic+t+oim9XmIP+wTZR9/Ky9fJoEv+BWZB/D9p
iPE6oT/2JUq/fDNUul497NhMJs7bmCmX01NT/ggIIZ5DFnZEA9Zzqj7opNgSFP7q
cQriW0mv7nrCaxUu9LIA05LKSDEMVYvyBiCknb4Ewc7kVGguZDdnfiT/iFCGM9jy
4xOL8MUATHLiWEZxmXgfAilNwaJjMXDhK53zyaHe7wDrqFwHCQ1SAFwkYSKpH+/4
vhU43ovlwUky2DjbU6Dj1bskZETaZHF8UQPzwiA3QsKneyfy4fqhl8+N/sKe9RFL
sWt+jfjpOdG4dI5u14gAcPzo1E3v04fxeSj9zCbZlC+DM/FTPNhOo/QDc/hAFFgB
TnIU4cTw/qxbBM0UPkkCbQOllEca4qorsiqGBFXXjj6INhKtbIkBN97cc2rAUyrP
KXMji3aT1yBnKJzaBv6DQTKQ4E36kSsmDoy+G1e5jCm0YONs850qFiQblX2lNFq3
H1xCH4KXihEq5ZoGuUvM1MS4mfSRe0Gn7QLg5M9Bv12o2GDGuH2nHHskZpUpljIb
yc6QxHN9sMclAJPJsP/QNtWDdVGVuW3uc023aqoMY87/PpbCQmkChWIrnuyu0GoW
2GxwqAa68e1nv3lirgu92NZsMsGMmEx+wbEE7zinlryPHoHqHlsTW2Ty3aEA2k3g
6qjaBSFbM1hGEW1tzpRV
=HP6s
-----END PGP SIGNATURE-----

--wpxcqqTuihheY91T--
