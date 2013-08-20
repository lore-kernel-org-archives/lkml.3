Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab3HTM3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:29:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56850 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab3HTM3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:29:44 -0400
Date: Tue, 20 Aug 2013 07:29:07 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <grant.likely@linaro.org>,
        <idos@codeaurora.org>, <mgautam@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers
 for DWC3 core
Message-ID: <20130820122907.GU26587@radagast>
Reply-To: <balbi@ti.com>
References: <1376992565-22292-1-git-send-email-iivanov@mm-sol.com>
 <1376992565-22292-3-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o3Y+93sjbn8Tp8J9"
Content-Disposition: inline
In-Reply-To: <1376992565-22292-3-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--o3Y+93sjbn8Tp8J9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 20, 2013 at 12:56:04PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> These drivers handles control and configuration of the HS
> and SS USB PHY transceivers. They are part of the driver
> which manage Synopsys DesignWare USB3 controller stack
> inside Qualcomm SoC's.
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  drivers/usb/phy/Kconfig           |   11 ++
>  drivers/usb/phy/Makefile          |    2 +
>  drivers/usb/phy/phy-msm-dwc3-hs.c |  327 ++++++++++++++++++++++++++++++++
>  drivers/usb/phy/phy-msm-dwc3-ss.c |  374 +++++++++++++++++++++++++++++++=
++++++

please rename these PHY drivers, they have nothing to do with DWC3. PHYs
don't care about the USB controller.

--=20
balbi

--o3Y+93sjbn8Tp8J9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSE2ESAAoJEIaOsuA1yqREIL4P/1cob1PswOBmMq65gFAxvk9z
PFIjvP3IMG7iTwt74CC9QEHMinZCkTQ+XMII0ubsZG7EIxayknJt8igTG2rY/KHH
7uWPYwuI89sDmGl3tCfq46rNqTvaZu3A9KRxmwBCDJFkaYF482KcIlFh6cdW8Cmq
R3VgpM2fnDYcgHp9TcpZVktMuynl2fYfOETvirFd9Sevvu5GGSG/HP7RWW0jhD8u
SYXVo+Et+MVRjqt0fcH1p9AxEz1iov0zTqubNkwjdgMN2teElP2hpt4VEMuKubnL
2OphTzPd7HmuTh5pMe/elOI9EfJfOufFTBrS7WiVzHwEjPzMfgjJRRjkf3BzNlqL
jDSimDF6hrQJm2DjTG0iwFxWtZX1FPeuERc4h+CgA2ED+1iipwNXvjdUrg/eOxj6
sBlYp0d3mjTa02Y7xXybTOooqADsn7ffUiMSWpkNXnzwEqXi3jnYtxoYxlY0lIGI
07O13LrJ+RhXcRIv6jmAPFVBfo91xbA/TJ5TkChCSixDQsFFeQZ1wJGeYEAIN1XH
8VWDTkjUiJiLDKLfUdzmzPgO/MN80SwFu46ojDBr8J48wXrMt/+x+4com4Wc7MN7
DvNx3BZfdOv+gKuemPlufE7n+OLER5XVPZyNR4vMd5AOW8yYbAjrfcTJ+7oVVRHH
OW0WfohqKLIyQtZhLxGS
=Py2d
-----END PGP SIGNATURE-----

--o3Y+93sjbn8Tp8J9--
