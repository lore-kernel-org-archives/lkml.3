Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaHFHUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 03:20:43 -0400
Received: from sauhun.de ([89.238.76.85]:51963 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbaHFHUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 03:20:41 -0400
Date: Wed, 6 Aug 2014 09:20:17 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Yao Yuan <yao.yuan@freescale.com>
Cc: Varka Bhadram <varkabhadram@gmail.com>, "marex@denx.de" <marex@denx.de>,
        "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c driver
Message-ID: <20140806072017.GA2730@katana>
References: <1407232563-10856-1-git-send-email-yao.yuan@freescale.com>
 <1407232563-10856-2-git-send-email-yao.yuan@freescale.com>
 <53E0C498.6070608@gmail.com>
 <30487e0abf4b4564af296d17f5cebf49@BL2PR03MB338.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <30487e0abf4b4564af296d17f5cebf49@BL2PR03MB338.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
> > 			     struct i2c_msg *msgs)
> >=20
> > run checkpatch.pl on this patch...
>=20
> Sorry for my code style. I will match open parenthesis in this case.

FYI, I am not strict on the open parenthesis thingie.


--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT4dcxAAoJEBQN5MwUoCm28f8P/1BS5rATojDksbpfftlxquQP
tU8kND+nhWI5OIamiGfP5+kuTq9wFydRgvm1MM4NVeJ8Er/xwEBKfiOVgcftL+JX
19kPUo0jBVxtu6zyW9NgTD7YZUzOPXpINHJEGQtwrcsJVXr7Z3ACfuQ4Ys8fbl6F
ivDSke+6gt7pc6U99t4C67twBNF/uESRjxY3Td+JubXsSbE48Ban4aY6khRt11Jf
XdbGL0PJO9kHo0RUCrbH9wAoh2m7ZdTPdgCkZgEco9ppZQ/mO39rf1sWKwOKP7TU
M7qA6xO5sK/t2Zv9mobtK/n9Di4CZxZsV7AyibYTNwjlMo4AYkgiJfHS5OcUMDHI
K1E4PscAta4Hgg4D33hiDsvfnAM677u1fG3J9B1H0Tc0d5HMrwLR+/Yb4EzvLbUL
GDfO3dOetosQuLW+1JXyRSBskfuwT5D9bE9rbnWEyY/wlkY+JbnDjkUhftzyhbwM
GOM16tO8H1T9go0/Dh7D5tQb4c4B7VJB2aexqzNPeYtEzcmVUHL/JsT+yDwlz7sE
/fi/7kBWDTEaikh7+XwmAix7Cn/cZcsuvIxz/Y7wcn5y64cx5jVPUB8twp/u/WFT
t2HLZVdjb54X4BFda/PQUjLDY5vbpuKnU+CWNZB9iITt6lFS29MZe3UtA/aumyDk
9OvkCNzpIHF23ATczoXY
=mxTY
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
