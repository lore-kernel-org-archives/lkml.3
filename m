Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaJMKsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:48:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50211 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaJMKsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:48:24 -0400
Date: Mon, 13 Oct 2014 12:48:05 +0200
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-kernel@vger.kernel.org, dp@opensource.wolfsonmicro.com
Message-ID: <20141013104805.GN27755@sirena.org.uk>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
 <1412845377-17134-4-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BldhxuJQ12PvT3+j"
Content-Disposition: inline
In-Reply-To: <1412845377-17134-4-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/6] regmap: cache: fix errno in regcache_hw_init()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BldhxuJQ12PvT3+j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 09, 2014 at 05:02:54PM +0800, Xiubo Li wrote:
> When kmalloc() fails, we should return -ENOMEM.

Applied, thanks.

--BldhxuJQ12PvT3+j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO63kAAoJECTWi3JdVIfQkLMH/ArefaTAb7XDWIOyVl3MncK3
JqlVt3yrI7pKJaWny61Pwxe9rg7h5KaSje0uK5LYUYdYCXy4gsFxNGNDC8Nn5lqM
kYMkTPRnePWw1jy6QajyHYjwfryW93HPogbGn4N1EEBjE+xzPMGOdrRUbYz029hs
AqUKTDxHMecLi8UO7jF5MPQTtVoRvB+XclUxyK1gRAasdx0a78h3hr6WZ7dHlSwO
79mwJrjYDCNSyebJFVd3/TOleh7HPKpLVu1D2TZAgdco4hxRo/qwLx19pZ7cLT+2
C2m/tiyS6Cc/GE5s7IJObzhWzetg5B4iI7zrCfgGbyT+3Z2RrlDpMV4+xu/mWeI=
=YuZx
-----END PGP SIGNATURE-----

--BldhxuJQ12PvT3+j--
