Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaBSQfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:35:17 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51803 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaBSQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:35:15 -0500
Date: Thu, 20 Feb 2014 01:34:59 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219163459.GT2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-11-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="39xYMTWOygaV/wdi"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-11-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 11/15] regulator: 88pm800: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--39xYMTWOygaV/wdi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:11:07PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thansk.

--39xYMTWOygaV/wdi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBN0wAAoJELSic+t+oim9xRgQAJ3AjWB8vRDvnfCousvHj6nf
PqFXbNvWY2g8aHPZGQdKtIctkbOil1EgRkddLI1k2hdU07Mn/J4QJbA3SLN7zmsg
g9e2PwyjOYROoCo6JXAmlJ1rrgcQ3sXCyceUaGxuSEdO8XB6G6DAOBduoLA1vpHA
fvv519PdnKnB2tyhOssTyMOuzRZ8kWUt48VLY2opfEb1J7wIkqw4H3JV/WhgHQ5H
mj35OO7oKlopSY7p9QDs6Xre0IPW0J4N0k9LJ8pGOAgSwYi3k/PZ1hb3hdCELio9
5MFr3A7KUqCtvJgO2yJ+T1IymhA613nokdXChin1MR91IiLevQfQv1GJhc66IZGX
D5PVTGavA3Vp1ylxvtXoq8g6WSntX1dtsigZ/iss8xOQlq2RdauzDGHsbDH7R6T4
C7UVc0VcAjVGQ96dck3LzxkDPV5hrJ17Cpw1zRsQAnbbzIjIzTgaBsWeO6LZoQzR
0IBe9lakX5b8kXBbEDDEBa2PHn3QVyAtyO+KhNlDM5NxC+4D65VbZnF5VGfQ5Igj
4yOyb5RYs3OOiDSdPMtZQo8G0Ve5VotO+fGYQT8az85W3QjrH+WGB0dKYzfYCAAQ
VKksOmAOV6sq/d+eIGsA3YxJJCRsGPPChBVvdQCMwZ03MbwBRdNOlnLU6w9LG03R
95S/zwJVZCdlDzbLoESM
=EEiu
-----END PGP SIGNATURE-----

--39xYMTWOygaV/wdi--
