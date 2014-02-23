Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaBWCcK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 21:32:10 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49682 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaBWCcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 21:32:08 -0500
Date: Sun, 23 Feb 2014 11:15:30 +0900
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Message-ID: <20140223021530.GD25940@sirena.org.uk>
References: <1393104959-12831-1-git-send-email-maxime.ripard@free-electrons.com>
 <1393104959-12831-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Eldrgvv4EWsIM1sO"
Content-Disposition: inline
In-Reply-To: <1393104959-12831-2-git-send-email-maxime.ripard@free-electrons.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.159.64
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/7] spi: sunxi: Add Allwinner A10 SPI controller driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Eldrgvv4EWsIM1sO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 22, 2014 at 10:35:53PM +0100, Maxime Ripard wrote:
> The older Allwinner SoCs (A10, A13, A10s and A20) all have the same SPI
> controller.

Applied, thanks.  Please differentiate between these two devices in the
subject line when sending patches for example by using "sun6i" and
"sun4i".

--Eldrgvv4EWsIM1sO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCVm+AAoJELSic+t+oim94BgQAJttAmEoi3Ix8FKOHo64QWiu
mwv3JTsqjzsm0I+brOwv3hndxJqekCyOaLvLG+Bn17UBd6Ao2y/GToWoecqcTrjv
Wu6+T7EQSPkWkGqpXj5D1v5EQPtkWSyZIKkxSzfWg2AELoFSzEzUzQYXMnCla3lT
wIf9IzAZHkSri5+O/EumHRue+J85qCO2tdFCdxUP8lekysQwuXIIjtWYLNhxNerY
vQqkMzCx8IU8kVEWT0LlLTS4OrdTjQDZKuxKAf6rk/tFOkpb6DuCPKHkbwcaEvFu
Pj4c2OlHG2wR8IKlnMSIJijNKfdgDFD9MqZx21dvN8EsovEZq/ZaX7eRobwcPG9P
eSCyFf5FJ2UoxLBx3rfwcFSyrENpGr6iN7phq5euyAdAmr98rbW36D9mMPTWIkP+
ZB5aL+t1sOtoPVl+7kEhb8jorjWNBbdIVLSdpnITjt51QKMmst+nhNCPd+LfsY95
XvewwWpxXe3t8XkHsBDAjIp7KAgIhVNPaI4gGxSX+K10/Urr62Nzv1lkUPSasrYy
FHchBs2svB6wJfREsM/Jwti/5GPidns4ulynUCcleJzEGXSy/37/hTEDFUvPzxlu
W/WxfawWSaCxj9KaGwrAhL7iEVa8FAThgz7xRW/28zk/Nwo72CtcGC1zMjCZ4xNK
ynofq0Q6sfGS9+bntH3X
=3jUr
-----END PGP SIGNATURE-----

--Eldrgvv4EWsIM1sO--
