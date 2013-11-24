Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3KXNid (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 08:38:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51998 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3KXNia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 08:38:30 -0500
Date: Sun, 24 Nov 2013 13:38:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131124133805.GT14725@sirena.org.uk>
References: <1384877043-5640-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384877043-5640-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5tINJiUS2/Dn5Rhr"
Content-Disposition: inline
In-Reply-To: <1384877043-5640-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] ASoC: wm5110: Add basic support for ISRCs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5tINJiUS2/Dn5Rhr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 19, 2013 at 04:04:02PM +0000, Charles Keepax wrote:
> Add support for the ISRCs that matches the current support on the w5102.

Applied, thanks.

--5tINJiUS2/Dn5Rhr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSkgE5AAoJELSic+t+oim9OPAP/3ki0iuu3r6wiijEBTKRO62h
C0KMbP55KjgqtF+ReAO04mngbSrO452GDRDn7tqG1u7CukRwkfhleqrqu/baDWDz
ttOzdnrzz0eUej31zNAaLPP2XLebZHyWe4DX8ETEvA1DTzb95zOvc4OLg0WmLNXr
0AzGH8/oKQQPkJ8aT6g04yZdNN1M3G1jBoTilaDAbu5RdH2dAQGIGGmSNe/qf4h7
WJqljqrDk96z4rjtaEQu4g910TN6lg2N1slJssvdbmD3sM+XvrU5RU69FXbN3yBp
zJcjsIk0FlvNiHsX+9YUmCTX3zpunQb3DSWohaBm2Lt6m6M0SxedVv11jUB409+e
BhInrbAiMDbXa4sKcF8B4TjierYl8D+TjChBlBI7vL9Vn//PCMwkHwj8Dx61GlTj
qPsZjOKKpNrujzpK3AuGoIp1PyNC+cPMgW9GL+McqzwKJ/khuX4igYRzNEjW2FYd
yIoOm+kh8YVAuBjaTV+h0rTxqOS9yYWcu0h3sDr5QWALyjU+5qZn8LmVfGGd2VUc
KU/8gno76g4ygeiGyLbZq2zoI4aO2CjqSDrihP71F/RItRyVrg1NiB4ktqb9YkQX
KPt5a28uY3vmOMr07ZAuhYq7vqlNTBsdU36Aw4UZwouSEACyAH6yl6LIl2LJWkB+
nBGISZ+fEGS0c7wxVgff
=sRsJ
-----END PGP SIGNATURE-----

--5tINJiUS2/Dn5Rhr--
