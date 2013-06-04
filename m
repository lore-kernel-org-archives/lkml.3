Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3FDUXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 16:23:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53578 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3FDUXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 16:23:20 -0400
Date: Tue, 4 Jun 2013 23:21:57 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 03/12] usb: otg: msm: Convert to clk_prepare/unprepare
Message-ID: <20130604202157.GD28302@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370373938-32417-1-git-send-email-sboyd@codeaurora.org>
 <1370373938-32417-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Content-Disposition: inline
In-Reply-To: <1370373938-32417-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 04, 2013 at 12:25:29PM -0700, Stephen Boyd wrote:
> Add calls to clk_prepare and unprepare so that MSM can migrate to
> the common clock framework.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

it's best if this goes with the rest of the series, for that:


Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRrkxlAAoJEIaOsuA1yqREnTIP/25kfKUw7erZlZHY7ONK6bID
9EPmFhscdPsbIYQ4VEC2+nbF5z8iEkkigLLUoWrw0goBwsa8V+hqG1v6j/zQ+WwA
j982BZ2i6yXq+7GcDWO2Skf1sga7X/i97JDWdZ0++kbKfBGJNXaOVlp/yAM51zYx
0CQfzLWmW7epVSWfbI6BdZMgeGv7slmN+ztYMKbc8rPAGeCCDMrONA1AE4hFXPTC
FDAP4eNRLRVyIt3a0FFXOYI48J/Ss2XHQOt5710vnBlrGd+xDDB9M2M5+VGYZWW2
47iWRudZCLCFTv475U+1iA3veFH/sz4OKDggFnElvh/kVkB+4fyjewmKJ1ah8Sei
gCXBw6K+7R8uBxziLGooM9E4TYx8PuxEFoE/SbsyB1ij0BIHOlk31Tm0UxvBe57z
Eu8tXaFAxEYyIgqeRQTg4AAyWKveVmYcu7K4ycH0mct9kRSU1+UM/FcQh77KeyPY
32L9Ieg+qOewHM3jTQXnaYMVPRFIjaLnEWiZL80bx2l9epq0fpdrjw3YKVIKGGq9
mkfUiS1ySbbvePjX/7Ji02+haUWErwHrEjxUClabbsEeNqKQJuCAsJSXGJTSHNvU
mImMliXdkyNwl/EbMNdmMAgk18p1AP90jdk7w8nlf11IOU0dOhz9QxrMUfmNTI7a
+WHGhsl9Uod8hcnFO7Vb
=RZgK
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
