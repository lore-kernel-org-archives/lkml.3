Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964850Ab3CNPtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:49:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60357 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964808Ab3CNPtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:49:09 -0400
Date: Thu, 14 Mar 2013 17:49:02 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <notasas@gmail.com>
Subject: Re: [PATCH v2 4/4] usb: otg: twl4030: fix cold plug on OMAP3
Message-ID: <20130314154901.GB3001@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363242239-1061-1-git-send-email-kishon@ti.com>
 <1363242239-1061-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <1363242239-1061-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2013 at 11:53:59AM +0530, Kishon Vijay Abraham I wrote:
> Having twl4030_usb_phy_init() (detects if a cable is connected before
> twl4030 is probed) in twl4030 probe makes cable connect events to be
> missed by musb glue, since it gets loaded after twl4030. Having
> twl4030_usb_phy_init as a usb_phy ops lets twl4030_usb_phy_init to be
> called when glue is ready.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

likewise. The other two I have taken

--=20
balbi

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQfFtAAoJEIaOsuA1yqRE1+8P/1t5C+bVacIIXmTgxWQycxiF
pJ0/FsY0uBSdMDA9LP3WvBtt6kqZ2FS37nnfsbf/8zpHZVG+B5Wck1K6QveHm7nm
LIKxWEvc46fE8ZICx2TR09wam/crpD0vn0eiAj06F1UR93r9iy6Ia3AWvuy4D49c
2NuMH9WOEC9+vL6mlFJS4qcIwTSnyKnv4iqhFVbaAK9/buFHXdItNbxfs45vhSwd
VsBbNKGwp/rSrU8biji+Wcr5p5GLSJ7XF5VbSB6HM2Dg25NKGoPlvYre8TWSFw6+
VxgrrO1lNbEF7t+DbveHvj5Wz6Md/dSRfzeUfD/Tl05QOHIZlgO3Ugv8xpB6eXZg
NUiH8hIhWpncXk5DuCn/JuRGCNVSNXXGZDahI17V77s/DpZTmz6s8yiFuaRlUyT+
8oqvWzvU3yPqhOVw23LtScAZZxDMS+zlCzUoaepFSBKq9D0hn1x7lWoSlNz5ZdCW
ub51Xm5iLt80qu7Yrtq3lngYL5+s5aVFKRIpM4qHvfpZ2ueD3BN0f3/2xPjyDrIc
LIhiZ8UXt5OzkjZxhTYJzuQPAdJcOy5T98Z+06DucBwrc9zYRNl4Hvs4Yew/GiHp
pJtgR27VgTUiWNvHm10+0lDSn7s4oZDr6sXemjVRy4MmIm3UBRux1kwXgCU8BPkV
VmaG7yJ99JbGNx+OlXE+
=EbxY
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
