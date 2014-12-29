Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaL2QJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:09:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54331 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaL2QJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:09:02 -0500
Date: Mon, 29 Dec 2014 16:08:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Aniroop Mathur <aniroop.mathur@gmail.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, a.mathur@samsung.com
Message-ID: <20141229160850.GT17800@sirena.org.uk>
References: <1419784718-3704-1-git-send-email-aniroop.mathur@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ESCox5UV10Jge7Qi"
Content-Disposition: inline
In-Reply-To: <1419784718-3704-1-git-send-email-aniroop.mathur@gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Avoid negative regulator no &
 initialize it to -1
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ESCox5UV10Jge7Qi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 28, 2014 at 10:08:38PM +0530, Aniroop Mathur wrote:
> This patch initializes regulator_no to -1 to avoid extra subtraction
> operation performed every time we register a regulator and avoid negative
> regulator no in its name.

Applied, thanks.

--ESCox5UV10Jge7Qi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoXyRAAoJECTWi3JdVIfQYucH/3BXs/iH3e3U5P8S0y/j2Hud
K2IJa8fi+R/MEla1Z0HcqKno1oW5csZ+iG45m6Gbzf2AFsbrWgQRVj8u1VLPKCW0
jDYMf+TpB6/wocnmZ9K/bWUWSAlXT33DC0Wi/6Ls3lgzZ5pKnAmfeesLA44yqmQr
QYgjMYJzPcLd844CE+Jm4h3ifPKt4WOgsNK2JazT61bxQnQ0Q8V0XKTmsCmVu5+e
rdFou02WJMcTc0GiLOs4SfoRYOeoq9Mqmc4EMqFFF7+J549havAZsSxcQlxJTYjw
Sz/JZq6a8NUp51bgpW7SPn2PUAh6vk+w/yHq+i2Umf4ekZVObnS0J6Np7WHSEic=
=RNXv
-----END PGP SIGNATURE-----

--ESCox5UV10Jge7Qi--
