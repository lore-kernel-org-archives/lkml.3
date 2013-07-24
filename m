Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab3GXMew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:34:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47660 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab3GXMeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:34:50 -0400
Date: Wed, 24 Jul 2013 15:34:43 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2 1/7] usb: phy: msm: Move mach depndend code to
 platform data
Message-ID: <20130724123442.GF17962@radagast>
Reply-To: <balbi@ti.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
 <1373384833-18077-2-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qxfKREH7IwbezJ+T"
Content-Disposition: inline
In-Reply-To: <1373384833-18077-2-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qxfKREH7IwbezJ+T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 09, 2013 at 06:47:07PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> This patch fix compilation error and is an intermediate step
> before the addition of DeviceTree support for newer targets.
> Fix suggested here: https://lkml.org/lkml/2013/6/19/381
>=20
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Cc: Bryan Huntsman <bryanh@codeaurora.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

I need Acks for arch/arm/*, I'll drop these from my TODO until it's
resent with proper Acks.

--=20
balbi

--qxfKREH7IwbezJ+T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR78niAAoJEIaOsuA1yqRENEIP/1UGLb4OeCED6AHfyM0sN2mz
W3k9wzraAq6t3SyEXDGm3ti0cbmnOZj8bqpyzH0qmyZQtzPoq8EJFc9Jqrg3r5DJ
cl1xXqDO3BpnfPwQZJk4OmOhJ73P4ECFV4BrhTsi8pDv9Se5ofC844BDzuyJK/os
t4Yb0e8CkQ3uS41zJprAuRMAxyz65D01PeGo3i3c3aeMHD3qDz57bIt7q+K75hw3
8qCH4f7Nc0R6Kcz9+fO0aVNU856AVmHavrezInD/pICbLXjj3gUB+ZQDiVkby54w
vEQlozawC7v7Heym7SVR3bPTKojOjJP5R4xsUo5txHOjfYHtUsp0OOY0uzh2Cops
xPrOSbDbU2dI+8C89OPergxaU/4IF/D0c5H39yluJ4espFsaUWlXqKkjSgEEKn5m
fPJMFbPEHk8NPQY+uEkiOhzO2fCpLVFf7e0RUet0uV0MkRC+W0StLuBmEMxCUWhO
mN+8CdzQmUqU+9csVphmNKnDnsHhxil8HXuKT7p8nSH52R+9VXQU2t3ylQOA0c3N
KL1FIXqsa8YMHxsOBD0rsDTep/hCrsmPhjTGO+Xhya3P99h3jjTBDDR1lAw8bU5f
HTYQQGlNExW/k2S1qmO7zksHmQ4+anj5RwyauD0mw9V3eGbWR+1v//uc1NtMjR2P
+EbWvCAnB3dHB1dc1Al2
=Css8
-----END PGP SIGNATURE-----

--qxfKREH7IwbezJ+T--
