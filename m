Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaKESaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:30:15 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55495 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaKESaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:30:13 -0500
Date: Wed, 5 Nov 2014 12:30:26 -0600
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rongjun.ying@csr.com>, <Baohua.Song@csr.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [RESEND PATCH 1/2] extcon: gpio: Add dt support for the driver
Message-ID: <20141105183026.GC6548@saruman>
Reply-To: <balbi@ti.com>
References: <1415201388-32060-1-git-send-email-george.cherian@ti.com>
 <1415201388-32060-2-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7qSK/uQB79J36Y4o"
Content-Disposition: inline
In-Reply-To: <1415201388-32060-2-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7qSK/uQB79J36Y4o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2014 at 08:59:47PM +0530, George Cherian wrote:
> Add device tree support to extcon-gpio driver.
> Add devicetree binding documentation
>=20
> While at that
> 	- Cleanup the pdata as there are no users for the same.

should be a patch of its own.

> 	- Convert the driver to use gpiod_* API's.

should be a patch of its own.

> 	- Some gpio's can sleep while reading, so always use gpio_get_value_cans=
leep

doesn't explain the fact that you have such a platform. Make it clear
that you have a platform supported in mainline which uses a GPIO from an
external i2c I/O expander and because of that you need to use can_sleep.

Should also be a patch of its own, as it was before.

--=20
balbi

--7qSK/uQB79J36Y4o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWmzCAAoJEIaOsuA1yqREQ20P/R3oqUJThSfW64y5/iUmktV6
ybsse3B11iCc+wsp4Ki7u3AzjCJRzPisGoStbWct2Xzbp/Fh2QNa1q8/AjAye408
g1Gjdxifxcgc/Y55dKmWuKA9K4tMnpceJJzG9LY4Pc3ekenZrENMhw57gvXqvE6C
0qS85aHLPG9DgdlTjSW6RwD3wKuVF4clKAoF0toOA81Ad06c+MTbAkcX/6tAqE6+
OcCkTLpeZjTUDrWFdd9PJHviOqKB3nV2rmf+34qWltE05L2xSBDMpKdXqdoDlrd9
g0jUbPt5BTMTKakFTa5faArue+XRfqa3UNq9UHO8cqqq4tWvK8D9aVnudFazqmVl
Uuh3t/uOTtYVGA8s83ExA9HZh118H9tLXOM+TSI3v7gokB60TZzD9tEJm4BU17FK
8N0HW+e09PoLOnBqo6oB3VtIA/erCrgqTIzDTfDqYDHd1yfR8j4R/bHr4JdL54d1
8FKRbMDdshDT7Og3e1WFwaUZd0e3L6Jc0PO5XUkDCtIyPbz3RSauu1dMoB5WtOcC
geOlllq04rjiEB8P1vYdU4DpcO/SWMBwFLBWnaXD6I/3sdP6NFz2SUVmWuRugnvw
2F1SvzfZU3tgovw+CprmxfOq/RNfBT/NXdxDWNttZxs4LOBH/KmiawXBXeA2R/YR
LwtZlnizuX5fNEqaC/rf
=vrlQ
-----END PGP SIGNATURE-----

--7qSK/uQB79J36Y4o--
