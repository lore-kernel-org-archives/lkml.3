Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab3FCPWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:22:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55368 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3FCPWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:22:35 -0400
Date: Mon, 3 Jun 2013 16:22:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130603152217.GL31367@sirena.org.uk>
References: <1370012520-30539-1-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hTiIB9CRvBOLTyqY"
Content-Disposition: inline
In-Reply-To: <1370012520-30539-1-git-send-email-richard.genoud@gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: atmel: convert to
 dma_request_slave_channel_compat()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hTiIB9CRvBOLTyqY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2013 at 05:01:59PM +0200, Richard Genoud wrote:
> Use generic DMA DT helper.
> Platforms booting with or without DT populated are both supported.
>=20
> Based on Ludovic Desroches <ludovic.desroches@atmel.com> patchset
> "ARM: at91: move to generic DMA device tree binding"

Applied, thanks.

--hTiIB9CRvBOLTyqY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRrLSlAAoJELSic+t+oim949sP/A0SYMMfg9BGc3ruY6DzHnYO
2AZqifvv5flWQw2dnq/yF9HepPJ6a1LfgAkgKeecPEzAgB/amcy3WfLXKge+KzU4
0xP4Z2/1aRMxZg4Xxeq7cMyf+fkbp3cTfYG/dsoEbPjQYwkGEO8PjOVlCLPMfB6+
I9ujrpGvLkrA/HxkblCxhq3JN5DYSJOGpX1n125JttBdePmFARcro7lPRsBqnLYL
Sc2/6OyFV21+KOYfeqCQ3qUh58GSauceCyi0nNqHSYzSpTEVphFLSPyI46oMcWHk
rIw/LW5axF1xJ1cO0oP5S4FuBkckOr12cqwOo6FExaQK9QYAzqndyTBj31TC9xNM
V+fjzowwRie86zycIhK+80xdNBbi5iM4dU7xDG3MTOQk/zM8WsiJkJBd67yewOkO
cP9hvlT5DntJGB3vaRjecuAX6zdYNBYXLtjTC4XB39tiqzD2NWgMdkUh2NjeqGam
WkNBWAzb/8mvU2n8uIaDc4I+ib/tVOLsQ16XjumM1umZ6OnEJbnXsLZb1qJ9HFG3
3FibrJHBxVcmSCnU27sqHAG45oVLZ81mbOtRxcpLMhbvVxBMpl9hZsIWYT/+44dA
u5uOBGDUWI4le3ZVY1F2nqelEWgapIs8DTc6xjX+FIzO9E2O/XgnqiBTQRYvcJDb
rE18PNO1P7MXWckogDFG
=aK1G
-----END PGP SIGNATURE-----

--hTiIB9CRvBOLTyqY--
