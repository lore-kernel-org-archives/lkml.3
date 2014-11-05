Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaKERyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:54:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:49074 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbaKERy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:54:29 -0500
Date: Wed, 5 Nov 2014 18:54:23 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: omap-usb2: Enable runtime PM of omap-usb2 phy
 properly
Message-ID: <20141105175422.GB2327@earth.universe>
References: <1415081826-9297-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <1415081826-9297-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 04, 2014 at 11:47:06AM +0530, Kishon Vijay Abraham I wrote:
> From: Oussama Ghorbel <ghorbel@pivasoftware.com>
>=20
> The USB OTG port does not work since v3.16 on omap platform.
> This is a regression introduced by the commit
> eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
>  and remove).
> This because the call to pm_runtime_enable() function is moved after the
> call to devm_phy_create() function, which has side effect since later in
> the subsequent calls of devm_phy_create() there is a check with
> pm_runtime_enabled() to configure few things.
>=20
> Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>
> Tested-by: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

stable annotations are missing. See

Documentation/stable_kernel_rules.txt

-- Sebastian

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUWmROAAoJENju1/PIO/qaxmwP/jOJAclsVuWxLdgvglrZhXSz
PgoRkEmSuJWaRkftVDGoiu3S94UG3bUQ5wjNnqVv6Xr8OaBcU5Q34UWZHRkoecsF
2Z6cb8UlBGYnFRDrN+LhVpktO2yjLBwpzRrW32O0ge58HZcVNxqB4R5T/Oqxcp2i
0HFkmRPVJtO9b5dYc8UwUc2/Dmeyo3+plixz37wuKuTfvwqK91ODHP9/iMsXmh8J
Hyo8y1GJZZGjeldhxN884rzqqnncUZJspkpAPPSXrKaNBkm7Cala3JSlVw19DbZf
v8qXg5nR5ryfkz0vjDO/PC0plClA6pTGctw7FmgGeMKYbCX+wvX4Vc03El1MVdWz
gfmATThK9VOy8zZKyBg13VstnjGvRa5f5CnkUze2GY/xaUI46dsWVQvTpb3qyCx2
wNR8TzxEHYRm3GbL7ja1HEzaVZrFN4MvnWFbsaMsYIqbqSvumGaFL4I1QWm+BBM/
uxOSI+3DPgcAXWoVQs43V7XVPOexXdGCAJkVFTKoYofAKiYZicFsAE2+gDSFm7QN
NKR9z1S/udKtS2y7iR7hJv4CRxyahwMUo590A+ep9hoAhf21+zumaq7b64vKEKXa
Ag1HcpL+P111X/RCJJlwKiO8yi4ci9ysKeHf1YzEvhMZeNtV1eis00p94+1Bu9y0
lx6pzUuE0EDCZHc1WviY
=sL/G
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
