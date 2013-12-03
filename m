Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3LCPJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:09:44 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35522 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3LCPJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:09:40 -0500
Date: Tue, 3 Dec 2013 15:09:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Message-ID: <20131203150937.GA27568@sirena.org.uk>
References: <1386079702-22821-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z/2SwVaBG11ut2fa"
Content-Disposition: inline
In-Reply-To: <1386079702-22821-1-git-send-email-linus.walleij@linaro.org>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ab8500: delete non-devicetree probe path
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z/2SwVaBG11ut2fa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 03, 2013 at 03:08:22PM +0100, Linus Walleij wrote:
> The Ux500 platform has been converted to do device-tree only
> boots, no longer supports platform data passing, so this
> probe path is unused. Delete it, simplifying the driver a
> whole lot.

Applied, thanks.

--z/2SwVaBG11ut2fa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnfQtAAoJELSic+t+oim9Z5AP/2fg320UphH+Amcu3QchaaNt
qPVSpiByAeERrF1YQYv5JM8JUj8zsXNnrQIAx6x2mK+3xfyxUrp4K67jrFC3qg3P
6JcX8wgtePKKQZ3yJreaFJFbjgDYbtEzvRc3Bwb8VhXiIxVeAKN+rCt/tB7gLYl2
dD0NlcxwdeVgU/VvD0ARzwYMTu94QQS9xk8UWcvRYvfXlah+fz0BhwnU4ylqMf00
ZamS+S0v2sh6RmHt8zImewEnQoJSLJ445fSyR46xctSnwcwHMiANzTDiwQomGt1/
0iF5d7GAACw420P/jjiIAvA0poqyAVgTuJJvO5UedRhtw8MGCfd6edxXsdG6ftm6
ezZv/EP+WF9UqH6c2l+LEf/quLkMaOQvA7V0ap1huZmD8rtQCRDURlu+lYQP454f
0mCpbxxIqoUmgQhL888FLPSpc4K2OkQo5l3w5NJfBzBbcJQi6v0LwMypUzuX4sfT
6CKjl12VwYystw8u6Ge+v3t9IKlyV+dOz9qomCsyVztJHQDv3nn+YnqdDCYVon03
gGJPlJrZUE4S/qdsqNKhdUcibLSuy+c2pEQPPm0QxC4TV9I51yD6KLeh+uFCvl3J
E1HuSeUtb6AN2qPTljlAorAKiDNkjM9rY3R63ltdSTCKAYDcJpIKCCgzaqB3T0uo
sQ0XSWsISQbohh0FVtLO
=QKVP
-----END PGP SIGNATURE-----

--z/2SwVaBG11ut2fa--
