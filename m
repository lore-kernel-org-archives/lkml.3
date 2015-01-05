Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbbAEUKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:10:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36736 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbbAEUKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:10:35 -0500
Date: Mon, 5 Jan 2015 20:10:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20150105201020.GI2634@sirena.org.uk>
References: <1420448659-9636-1-git-send-email-k.kozlowski@samsung.com>
 <1420448748-9810-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uJWb33pM2TcUAXIl"
Content-Disposition: inline
In-Reply-To: <1420448748-9810-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: max8649: Constify struct regmap_config
 and regulator_ops
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uJWb33pM2TcUAXIl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 10:05:47AM +0100, Krzysztof Kozlowski wrote:
> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const. Make struct
> regulator_ops const as well.

Applied, thanks.

--uJWb33pM2TcUAXIl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqu+sAAoJECTWi3JdVIfQ+qwIAIJB6d00BWIzNGB4XF47lC11
jYgWYjoWf27QIjxl2qqjfAP6l+tVO/HJyw4o0m7/pIJo2dT88yw0pNvxzUz6nUUt
IG8X/vZfWw71/2+TpEkmgwIZnqVhe6od4VYepHPiRnNWaXem0RF2BOMrFwNwtBm4
moaKaPRvR9hQegEseox/U8HLat/saxf7+p41+HuTW15PmyoPQfEfSLllZh4iy1rw
+sspIlNwroBxbxxAAaNrBHfc5E5TCLU3EQ2wMZXGJexnLS6uSC3HeZZ++MTfErlw
TAklS+0aoZqub2YMihx1tE/73eckdKrgEeFWiABE11OPyS91XEhmXLuLT0zQJmQ=
=Td2a
-----END PGP SIGNATURE-----

--uJWb33pM2TcUAXIl--
