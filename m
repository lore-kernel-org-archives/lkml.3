Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905Ab3IPPS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:18:27 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:44846 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3IPPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:18:26 -0400
Date: Mon, 16 Sep 2013 17:17:17 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpu: host1x: use %pa to print dma_addr_t
Message-ID: <20130916151716.GA5613@ulmo>
References: <1378960909-15773-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <1378960909-15773-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2013 at 09:41:49PM -0700, Olof Johansson wrote:
> This removes two warnings where dma_addr_t variables were printed using
> %x when built with CONFIG_ARM_LPAE=3Dy, thus having 64-bit dma_addr_t:
>=20
>   drivers/gpu/host1x/hw/cdma_hw.c:57:3: warning: format '%x' expects argu=
ment of type 'unsigned int', but argument 5 has type 'dma_addr_t'
>   drivers/gpu/host1x/hw/debug_hw.c:175:10: warning: format '%x' expects a=
rgument of type 'unsigned int', but argument 3 has type 'dma_addr_t'

Hi Olof,

I can't reproduce this. Does this perhaps depend on some other patch?
When I enable LPAE I do see similar warnings in drivers/iommu/tegra-*.c
and those can indeed be fixed using an equivalent patch.

Thierry

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNyD8AAoJEN0jrNd/PrOhRsAP/208GNSrh0QqcEKk3HYahT0e
nCz5wR8KHgK5r6M7GBLo2N796Yc8h8FrB8U2Wmt1CrnoYc1P6cKqmPVCJHMbefl1
JUAC2dz0Zv+ryP/8pqJ5fHwqSuhjeOpsSVZdJ00/kFwTGm/6J0G18+osOtEduhtK
Ri7h7p5iZo2KDyPZSrwYXKyTzucdQOHP9W6aOYDV9ZCmb87jozr5NKEDfjYMQ1kf
SkpSdoCCIeJuhT586kqRp9TXQ07JVhwjYexZUfA3PExWODU4REmXQbSZL+cgs5zz
pPIjM3SX6jJt4hFDfkh2kISencrmvHbCjwdMHcOc62mtWG08Jnd5yfUAkQibMbOg
d21DPdIOEMvnr6XR7FTXSN3KLsUW25eWwiRgrhNexaGQWfe/j/XxH2nGsVM8ZS+4
DWiOJg3C66A4eKo1ZPG0RFnHu05eUDvexqFX4xzlOfNl60SOaioIj8DJ6WDuUXNm
/eqTSMXxrgKaNe4+aSCzzLEiuYMLqVnHmUHfybSM36ZrMnh24Us5OoeSSUCl9WKW
Vg+R9Oj7x8mT8oXkrlTZBy7pT5M+2i7Pp+jwJFyf8G0VZtDYRlsu4SgfBTCB4kxR
KAWN787XEFyQJeRfLiS4egYKq56OQE3vJVxVEHymBW+pds5MpZMloztdH3Qssx82
4aTM52OiAExTD6mFs2eZ
=Tkd3
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
