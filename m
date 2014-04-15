Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaDOCRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:17:20 -0400
Received: from ozlabs.org ([103.22.144.67]:39310 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbaDOCRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 22:17:19 -0400
Date: Tue, 15 Apr 2014 12:17:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harini Katakam <harinik@xilinx.com>
Subject: linux-next: build failure after merge of the spi tree
Message-Id: <20140415121703.055d54d52e9d2d325e9987f0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__15_Apr_2014_12_17_03_+1000_NemglzSVjaurFHGH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Apr_2014_12_17_03_+1000_NemglzSVjaurFHGH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the spi tree, today's linux-next build (x86_64_allmodconfig)
failed like this:

drivers/spi/spi-cadence.c: In function 'cdns_spi_write':
drivers/spi/spi-cadence.c:135:2: error: implicit declaration of function 'w=
ritel_relaxed' [-Werror=3Dimplicit-function-declaration]
  writel_relaxed(val, xspi->regs + offset);
  ^

Caused by commit c474b3866546 ("spi: Add driver for Cadence SPI controller"=
).

I have used the spi tree from next-20140414 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__15_Apr_2014_12_17_03_+1000_NemglzSVjaurFHGH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTTJakAAoJEMDTa8Ir7ZwV0KgQAIQSwGTbztxHFdzGJx0PYqla
TAvYQEs77nzxP1a7kaoATDxTz7+zlZdcIXl5+R/AIIHtoBNBgJvFUI8y548TX5ET
1j0lXxrn31JB3yz6Av7ueP68uZcbfsTOkOXCc3iySWvV9a/TRBbXnugYgvQEFhI2
johPUc9NneyhA4GaRF0uWk0zuskEuIHp7KBS72BXUkEJq0Pm03wL+mflTFK1xYRt
tgPdzV/YJ8Uz8wuZ4VulbaFCCjY9Rk5XuRwCz/8CnnHMOpRW2fEFncq/vJcZwx6/
JAJzQKcgCCYXdq2O6IQ4sF0X6hjeqEeuwJqvC6pBkCiJB+xoJI4rHLBJBIEjzcoo
Hvu5FxVm34ry0LYRRfm1HSxQhuKaQF90KLmNcf7T12hzUoIG/DAVGZ3HomXyw+lg
ntRMOUWjaigY/Tdnay1GtA9T5FjdRaueKoy2S9u1LVkZzBe4UPVJQlirLUOjfJEO
lxLU/aWs5TghhK8V80pUqoP67gCPq+jCVIUjWsyFHJmh96lMJe+E+p+XpFl2pIyT
ra941d4DEIS5MlkdVh7UFB9HUFeeEIiiP04vtNVnpF91yJbUGWU+Wy2vXmuvJzLs
SImwG8FFsPLKTI0fJSy8dsADgfmilRZMaiJDFqpRqzQUdZssDVr1jLXqLmff2wbj
jdHQ79gGrb76G8dRrB6u
=vkFH
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Apr_2014_12_17_03_+1000_NemglzSVjaurFHGH--
