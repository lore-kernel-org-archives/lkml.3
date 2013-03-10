Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3CJWvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:51:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59840 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3CJWvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:51:21 -0400
Date: Sun, 10 Mar 2013 23:51:17 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@wwwdotorg.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        pdeschrijver@nvidia.com
Subject: Re: [PATCH V2 5/5] ARM: DT: tegra114: Add spi controller DT entry
Message-ID: <20130310225117.GI4743@avionic-0098.mockup.avionic-design.de>
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com>
 <1362852678-13421-6-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PWfwoUCx3AFJRUBq"
Content-Disposition: inline
In-Reply-To: <1362852678-13421-6-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:glJbaQnLz7gVHyfQN9B7t5mIkvv2rs3p5g+isHQgLKn
 UjlfiuecYzuQ+hJQYSQfL6EW5wZLjZR6NJopaXw1q084m8E9bq
 9TcEfxNnClGJI4fnj2SFa5JDJ4VWa8I+vilYSvB0VrMpT2e6ZX
 obDNy+cVAhj6hep7TKI9zjgumKiEVrvGA/DY7sX11pGw/9c1Qw
 a3+D/YsfuIU5pva4xaZ4nfJvVSPiojV2OxJBK4knVIk3ElZu8v
 7Jj9drZqXrFmjbcmrg4KQjB6LdfWlwkAAIaUHX8zIw6LwpPQDF
 rwxYwvbf2MNd8RDy2MnkSdB5jwhe5Z/EFIldoWd4kKH/6SfowI
 BNAuNULIccTA975fpVf8UgAAB6YkQjwNEdTkXN4pMLmVMlCgPX
 HZeMCVWakXHeIS+IB53DtBxiw7Z+z3qxQvCLqgtDLmYyqFPbP4
 REQtV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PWfwoUCx3AFJRUBq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 09, 2013 at 11:41:18PM +0530, Laxman Dewangan wrote:
> NVIDIA's Tegra114 has 6 spi controllers. These controllers are
> redesign on T114 with different register interface.
>=20
> Add DT entry for spi controllers and make it compatible with
> "nvidia,tegra114-spi".

Similarly, SPI is an abbreviation and should be in all uppercase
letters. I can't really comment on the rest since there's no TRM
available publicly to check against.

Thierry

--PWfwoUCx3AFJRUBq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRPQ5lAAoJEN0jrNd/PrOhl3QP/Av24gaUtZdgUx0lPl2RY5DM
mBqTaLittlRHw0v6WLGiidS3ZIRN2lMn33XZUC6UTZs9Z8xoDokQ90gTPWJEFQe7
yAfV7b0xg5m6yZ4G2iV98wx2llJQcmXtYEBc/cxayYxLOwt36PAQfmUC3eeddUD3
wgKovUpbAT8cBkFYG85oMMbKfjf3ag52ipBrO3NqO8lt7nY2HlJDOsMOddlUUdG8
BoI5tvh4EFn5P15KDHdlZbSq5H05AwZuxCQaFqwKw4Kw+RZtyIHHtuLNlhXPqnOs
gVHA6hEpAKJJEKjfSdEygtzhb2EQBW/zatK5nhmmUjnIUwYecSWLIoL2OcIB51Mt
ZlHqajVgyhON9k66s9NfVxp25zmrh2CjcIEIYYTCKZkPedG8n1+jDBXVNONRfUWt
A+yM6N7sbUtT3tYPsS44psta0U6z/Vc2FG1V8xF+d4bYwgsHyf7lXxaC3hxDb7cl
GaI3yUBLhz6qLXrVvM+7u8fxsywJGoFm5G7ZnJsJmT/ROWBS2XNO9gXzjyODhg/a
ymPYP1c+9D/+E8kp5/0sFbeZ0i9syZMexyxW9QWJFJHyBL8NKj9xy3m60IKhjaIT
HW3jtzLKYZZrtwpyB3JhI1DtxgjGmlyspQliVEWWSx/zT7uSQDAN+u+BiOYBUyqE
2qsRIEH+Jg2SQE6BNmKQ
=zxVZ
-----END PGP SIGNATURE-----

--PWfwoUCx3AFJRUBq--
