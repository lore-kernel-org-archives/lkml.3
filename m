Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935177Ab3E2R7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 13:59:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35249 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934764Ab3E2R7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 13:59:07 -0400
Date: Wed, 29 May 2013 20:57:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <davem@davemloft.net>,
        <herbert@gondor.hengli.com.au>, <vinod.koul@intel.com>,
        <arnd@arndb.de>, <linus.walleij@stericsson.com>,
        <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
 into the driver
Message-ID: <20130529175741.GG21290@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-21-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/i8j2F0k9BYX4qLc"
Content-Disposition: inline
In-Reply-To: <1368611522-9984-21-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/i8j2F0k9BYX4qLc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2013 at 10:51:43AM +0100, Lee Jones wrote:
> For all ux500 based platforms the maximum number of end-points are used.
> Move this knowledge into the driver so we can relinquish the burden from
> platform data. This also removes quite a bit of complexity from the driver
> and will aid us when we come to enable the driver for Device Tree.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

for drivers/usb/musb

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--/i8j2F0k9BYX4qLc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRpkGVAAoJEIaOsuA1yqRE6v8QALBoV3kkhWM5sDVzuZCCWlMB
XLCfsgjK4qc0F3FBBEACkl4sU86APPSADaI1asBamWQ56zRl95FB5Ggzt7kdRxCo
klkyuNbNtidFaRss27WJOnzn3rU9FphjCbmDv5mbW6dR4v5FqJeD3VpPMAXgKSjo
N5DngSrLRYuj1mftAM4GeCxeJURl+4Vx/gvFpsqKPuFq/Z+jmxZbM9HFeJptkaba
1SZhkCxsEhF/sLxyLcmnQDxuyB3u4ExVzKZbc0TAUI49azxd0m7f/kwZ7hpA91QM
kkK8aq/FGrqhY0cVuLhxT7WvIw+4UxSSSNgEl5eycQtK+zhm7h/JDW9M79GZulJ3
SBJKWPJjPC1x5iGPz7itkCoMrWMn+mpnCy+B/bSQBZTTTav2cNvntvvhRp3QvPJo
zie+0phWGXFKRoBBUOiw/o3qZxJ6ioOFoC8WHbqiuuA+l1Nkm3WFEgj6EQhLXGVV
BRoJpcsUsDlkLmrN0ffupTRxCKJNlMiD1pwbxyBa7dv1Hapb12DOkNIEo5kejequ
6pulkBDd5VhgIRqotwfZoLOfSvI4yYyuAGm9fW06PVEsfpUZjQYkyu/IMFMk+JRE
0AT02dKO39rj+914Vi2xkR3cvMS8GzM7PTKeMga3FM1dd1l0g6L+XinVL6VCfghE
ZVutlZ2vNHBFJqFTeZnD
=9Ex2
-----END PGP SIGNATURE-----

--/i8j2F0k9BYX4qLc--
