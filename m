Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3FRJv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:51:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38858 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab3FRJv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:51:56 -0400
Date: Tue, 18 Jun 2013 12:49:42 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <grant.likely@linaro.org>,
        <tony@atomide.com>, <balbi@ti.com>, <arnd@arndb.de>,
        <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <akpm@linux-foundation.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <b-cousson@ti.com>, <linux@arm.linux.org.uk>,
        <benoit.cousson@linaro.org>, <mchehab@redhat.com>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>
Subject: Re: [PATCH v7 0/9] Generic PHY Framework
Message-ID: <20130618094942.GY5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <51BEE203.6090103@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8a48p4KKsB+A/3VY"
Content-Disposition: inline
In-Reply-To: <51BEE203.6090103@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8a48p4KKsB+A/3VY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 17, 2013 at 12:16:35PM +0200, Sylwester Nawrocki wrote:
> I have already used this API for our MIPI CSI-2/DSIM DPHYs driver,
> the RFC patch series can be found at [1].
>=20
> Thanks,
> Sylwester
>=20
> [1] http://www.spinics.net/lists/arm-kernel/msg251666.html

one comment to that series:

let's make the phy names standardized, how about phy-exynos-video-mipi.c
or phy-mipi-csi-dsim.c ?

--=20
balbi

--8a48p4KKsB+A/3VY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwC02AAoJEIaOsuA1yqREr1gP+wUX4ATtRcf9e6UYNWg22b87
GzL13FHHyH6O1mj+Qs3BfDYPMDHZNDfnwBBhxgBB+DlhgeyyCn0Ry3zeneA188wz
OCXsD3pVWqZA4REcXF38+aZQr/fB54TYsF7DiKkqYid8IzbjFunKVn1KFJUZRemA
yqr9DZNH4h44nvcB+/+k+G7tu11gbipklbq94cEr4FzRX5rTGWyXoxvl+N7WM7hU
O9XLhvuAsIMwzSAIq7iFxq0ZhSUzG1Gx9bWh73M1Yhbg/5zaGw36Q+GXJ2Gm1eYm
/dLWiKDfD8N1VDlLjfH/7kAMcCCaGVDtvOU2GA35RP9h4mSF/2EeaxoCqcZDgUHQ
ieSverpduDO2/Kq9ppDlYHs/9bLfPKi8kDwNgKdpN8mRls61+u0MdSe/tCHzrnZ9
B0lVpvzYiPPo20ldNb6Yqm5vM97RoLgNjPGbsSuAZbDo2VC/Y5U/qnqls1fa6LaF
XTyMuZFbN52QYa2ls1or8d6pXKcsKA1kQFwZpQ2uCA5gmCtb0D4EfcITbU827/U9
KMk9dLH8Wwzics97vraM7v27DQjoeBTzbMb7AIu7VQYNyOgNJ+NLDvZN8cumdkd1
Fomw/4+ASxRS7b4gRzRcxHMmN8LDSafHGeXCtXYR/B3kyb3TW0UoH4kRgWDUlPPI
Iv/HxD9vQzbKyKpYQtPw
=5awi
-----END PGP SIGNATURE-----

--8a48p4KKsB+A/3VY--
