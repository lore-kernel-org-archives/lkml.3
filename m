Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3BEJlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:41:03 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52588 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab3BEJlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:41:00 -0500
Date: Tue, 5 Feb 2013 11:40:45 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 30/30] ARM: OMAP: USB: Remove unused fields from struct
 usbhs_omap_platform_data
Message-ID: <20130205094045.GM32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-31-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ngshnjhd05HsCES+"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-31-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ngshnjhd05HsCES+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:31PM +0200, Roger Quadros wrote:
> All users have been adapted to the changes in ehci-omap. We can now
> get rid of the unused fields from usbhs_omap_platform_data.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--ngshnjhd05HsCES+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENOdAAoJEIaOsuA1yqREVcUQALTT7mPdHDJRlmZUtX3+UsKS
vn1q5MgC80RJCpLbWFhseQsAyFVmd48+PwsAmT8wVfOJFo5pSKX6eU8U9d4mYtzJ
CqzRAorloxImuubFeHcc32td3qn+x5cRcB8FTplMZ7Bx86tdkdk1ngpPo0Td162I
VkmSqil2e75g3gyzB1aT7aJUmeKygtyPfFCE3YqCCKi37mu1KYNomID44kZJAswX
DOg9K48pI3Uufm4F+93m4om6nJ+x0B+a7Rh2KyIP7mwlEGZi1pNkmZgmIs/Y1v4+
D5a+6NF05QqGjggfsfgPrvxcW1ydIAlBVeulpm0lmIxuQByJ8y0R6zX7JRV+J098
6N7z2TI3BooYpzDjrwh3w5yjKAyUqeMdG61anB4da+juRrIN1l4k5E8NGr81V5Cb
soW1laNCS4afPlCpLu1/ecdc/lzGE4FJrmkwDrCzd8c4bIa7jidHUsbjaqzGo3d0
kv+xn2hC47RP/kawH8TguVPbU9QgLbhzWCnZHFVh17ra43qcc4npWpuQCwMNiqG4
134m6BSe3MTu1tz0hObULVdWro/6lbVMKsQ3+lVDRDzza63ZX37ppqdhPe3knJa8
QeNO1cdgj6pKUPC3V7C2VA7aGAuojOd6mn65TYFST4ljer5bUFpCBqlez2c+9riq
xSdBHshLAGkSoJ1tB2Qc
=RFI4
-----END PGP SIGNATURE-----

--ngshnjhd05HsCES+--
