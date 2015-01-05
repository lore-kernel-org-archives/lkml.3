Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbbAEPsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:48:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36384 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbbAEPso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:44 -0500
Date: Mon, 5 Jan 2015 15:48:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Esben Haabendal <esbenhaabendal@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Stefan Roese <sr@denx.de>
Message-ID: <20150105154834.GV11764@sirena.org.uk>
References: <1420472564.803.9.camel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cUzoOeFTT7puyy6E"
Content-Disposition: inline
In-Reply-To: <1420472564.803.9.camel@gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Backport of spi-fsl-spi bugfix to 3.14.y
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cUzoOeFTT7puyy6E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 04:42:44PM +0100, Esben Haabendal wrote:

> Please consider commit 4302a59629f7a0bd70fd1605d2b558597517372a
> (spi: fsl: Fix problem with multi message transfers) for inclusion in
> stable kernel 3.14.

> It fixes a regression when using mmc_spi driver on top of spi-fsl-spi
> driver (tested with powerpc mpc8313 based board).

Has this ever worked?

--cUzoOeFTT7puyy6E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqrJRAAoJECTWi3JdVIfQWi8H/1kxAGrrDcnP2l4IFYBHJZ8e
oL2J/Isl2HVPmzfbo5e8TSyV3KPIFnBTPM5GSu0cDmsuI0g8yxKtLrdqgxzvQbGm
S4WdQ2SkCtGZmGbOfQNlMG6AtSIwIiQKbjnVgy82Z9IC++KX2ZBIJSM5O/YmcO/G
v5nAmuhuab/AiSZjHKzgsVHhoBnhsbRBkaxplX7morQhG3K/zAI08lYnRqr3haML
T+QmhGGAc368YiLNXu3+USDsuhWeKOoV17G+jAcvqnf6Dsq4MqpHhj4QLGgT7rd9
z5KegOTWt508Ckv8ADEBoQ7omC1OylmkaQTVQBcmsKnArYfBBAvyvN7gS/F1ifI=
=3OrN
-----END PGP SIGNATURE-----

--cUzoOeFTT7puyy6E--
