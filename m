Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaKUT1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:27:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34097 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaKUT1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:27:02 -0500
Date: Fri, 21 Nov 2014 19:25:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20141121192542.GM3815@sirena.org.uk>
References: <1416406386-22923-1-git-send-email-rf@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VaPfWKFh9aVm1sXO"
Content-Disposition: inline
In-Reply-To: <1416406386-22923-1-git-send-email-rf@opensource.wolfsonmicro.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: gpio: fix parsing of gpio list
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VaPfWKFh9aVm1sXO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 19, 2014 at 02:13:06PM +0000, Richard Fitzgerald wrote:
> The list of gpios is defined as optional but the code was
> failing to properly handle the case of no gpios, and also
> failing to check for errors reading the entry from the
> devicetree.

Applied, thanks.

--VaPfWKFh9aVm1sXO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUb5G1AAoJECTWi3JdVIfQfUIH/imbFeRlejV8QsyperBOqOI3
ZQ7hEpWQeJkqBvlT7PEP50qNndzb0niamqTXalqqu0/Id+eJCKP4y18TbUVbTdxm
pKTwQ9sFxFhNa/mkei+fnFNlFCZsJabldkcDfHCMKNbZMK6EWQyEKXot8NINoU5B
U0h7aI8XDFirSdp/wQt0jehszEdOj8rEaKPapEa0hVCsLobYFJD4Y+SNFVFvDmYk
MHuXTPw0240h8NH9fYk2PzuRrtWxFMXEbj6FUGHykPVpoAeZKhXepcserX4DxwBn
2DEShRkD2gjsHsYIdbv7FPagR4pmviPL/NZzHwFpeTO4Ya8SqKQME24KjokR3UA=
=+gZj
-----END PGP SIGNATURE-----

--VaPfWKFh9aVm1sXO--
