Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaBSNHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:07:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43182 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaBSNHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:07:30 -0500
Date: Wed, 19 Feb 2014 22:07:18 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219130718.GU2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-3-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e3uCoXrYjVSJCPdk"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-3-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 03/15] regulator: ti-abb: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e3uCoXrYjVSJCPdk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:10:59PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--e3uCoXrYjVSJCPdk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBKyDAAoJELSic+t+oim9FMkP/RW501ZXMI2aTgT0W4Rm2IEl
iLgMW4SG32jreciUaq9f5+Ds1cOJKXlrMRnADEVdWd03X8g5h6i+WdVLMbSAg1Ag
TKzyhciWbonmxtHygyWANWSPQbqb+CM7oJ1hRJ/Gg3dyFzre5WcUvVpV0axRbdas
Bx/EfSckOr4ljIfQL4GH+iK2MC2HdIqZdgxRdgm+msNnqufZ0nZEcNMen3CPiJ46
0mwE86YiwF5NPZ+GPAVK82g5ivlfI2+fOVxjTu7F2Q/nnplR5GfdK8+/UrLrzy25
Chwwaaq6za/iu7S3UzXzLt1FSBm6XoCw01cDy8sukjNVpkqZOBGVa+5cWnl4HIfC
erGln+WsKSpOwmpjFDBdu8Q7gu1hiSWdHNLFOZHbKlKbLyMIKs9qkMoEbZ1pN2rU
CfoeB3WmPtPABRnmq92HZv/Cd5YsQXheq3xrpTbnLlBV0aMoFFwxFyulrLSnAwz9
oNS7KodtWBjxYAmmwwNReUV2op6BPrEn8BSBY9eDkC58iHDujNgueie6zXHZhKdq
2rxTA5sNg9il/aW4YTDRXGlH6QWrKZt8P8Hxni/Rnkd7yFP5UZedJ5fKAQtmk4i3
cD4AeiPnLwz9sfz4uzh6pf9KJ4abW1twvjwwyBPuhWBJs8M8bWgU4Tj205VUnn1I
l9mkciDmOAjOB8EI22YQ
=iwh5
-----END PGP SIGNATURE-----

--e3uCoXrYjVSJCPdk--
