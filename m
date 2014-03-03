Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaCCQnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:43:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37469 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaCCQnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:43:13 -0500
Date: Mon, 3 Mar 2014 10:40:51 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <bcousson@baylibre.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <george.cherian@ti.com>,
        <heikki.krogerus@linux.intel.com>, <rogerq@ti.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: Re: [PATCH v5 0/6] Make dwc3 use Generic PHY Framework
Message-ID: <20140303164051.GB10987@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393846695-14644-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <1393846695-14644-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 03, 2014 at 05:08:09PM +0530, Kishon Vijay Abraham I wrote:
> Added support for optional PHY in dwc3 as not all SoCs having PHYs for DW=
C3
> should be programmed. While this can be considered as a temporary fix,
> a long term solution would be to add 'nop' PHY for platforms that does
> not have programmable PHY.
> Adapted DWC3 and USB3 PHY to use Generic PHY framework. Also changed the
> name of USB3 PHY driver to PIPE3 PHY driver since the same driver has to
> be used for SATA and PCIE too.
>=20
> Changes from v4: (sending the entire patch series again)
> * check the return values of phy_init and phy_power_on
> * print errors if power_on or power_off of PHY fails.
>=20
> Changes from v3: (Sent only adapt dwc3 core to use Generic PHY Framework)=
=20
> * avoided using quirks and rely on the return values of PHY APIs to find =
the
> presence of PHY.
>=20
> Changes from v2:
> * added a couple of fixes. One is invoking phy_resume after phy_init and =
the
> other is power off phy in error patch
> * used quirks to identify if a particular platform does not have PHYs
> * removed using separate header for pipe3 driver and also removed all ref=
erencs
> to SATA and PCIe in pipe3 driver since it's not yet adapted for those dri=
vers.
>=20
> Changes from v1:
> * The logic in which the driver detects the presence of PHYs has changed.
> * patch ordering has changed
> * udelay is replaced with usleep_range
> * A patch to remove set_suspend callback which was deferred from Generic
> PHY Framework series has been included.
>=20
> Kishon Vijay Abraham I (6):
>   usb: dwc3: core: support optional PHYs
>   usb: dwc3: adapt dwc3 core to use Generic PHY Framework
>   drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic PHY Framework
>   usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
>   phy: omap-usb2: move omap_usb.h from linux/usb/ to linux/phy/
>   arm/dts: added dt properties to adapt to the new phy framwork

patches 1 and 2 are in my testing/next, I guess 3,4,5 and 6 have no
direct dependency on those, right ?

--=20
balbi

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTFLCTAAoJEIaOsuA1yqREt1kP+wX6Shd/dZdsubpGv+I+fEVl
sMInbt/HfO8bKjFlZ/NMYs27WGU0FRmzlVA9jFHtRg+cZCVVKKyXyEegnveS/kTV
MkG1UpwV2Ml3/emMDvIjV+opdtnVvy5FPqfc39GT8P+4VukWHfJW41k7eifZV5R6
/GF03OB8qcCR3kv2fsKr4MFTvIqMkoCMBo2szjAk/qZixQKAwmXZR5+6VpPrQtt2
k7YF0M4kzs/hQ0RllqsHB6wK8YacorpL1I+xlQ67zhcIqyL6Qq+p2TmZpguMFlU3
iFGdx7QUeclawz7Xuq4WicYUW4Ouw7J6b4LGjAoGmUVO69jEex0gVRxas5yvf8xH
x67qdZtTPgyMDbbSjbO1cMU9o9Fb8HpYZUo/CyDSE675m+V1eMNo+01y4bBCkywb
7TNGWvm/mWlTNqaPQQ/DIrStDijSShLhLllc+xJggTk7UdES2s8YqT4jfyicA86W
PAuusq+bXZP6eOGEke5hNOJHG7Bxbv7wAbDMd+CCi+r5ZbeCW0TDVEK7o8Y3Ohmq
i0owImJeT2UMBaNc9/55G5S9C2wdoA0csLX1/Hye5LFkarB9xXdfmxPi/+rBtUdl
/HH/juGyi+VLs58VumIKlplfDkttgZpBLvCUQTBgPB9PNwEesua1MhRw1EmTI9u0
ccgCmoUXNXMAQcA6Hz1Q
=fYr0
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
