Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaDVO72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:59:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57711 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbaDVO7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:59:24 -0400
Date: Tue, 22 Apr 2014 09:57:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v6 01/19] usb: phy: msm: Make driver selectable on
 ARCH_QCOM
Message-ID: <20140422145701.GI5524@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
 <1398158438-21579-2-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="451BZW+OUuJBCAYj"
Content-Disposition: inline
In-Reply-To: <1398158438-21579-2-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--451BZW+OUuJBCAYj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 12:20:20PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> Controller could be found on APQ and MSM platforms,
> make configuration description more generic.
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  drivers/usb/phy/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index 416e0c8..0c668a3 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -171,11 +171,11 @@ config USB_ISP1301
>  	  module will be called phy-isp1301.
>=20
>  config USB_MSM_OTG
> -	tristate "OTG support for Qualcomm on-chip USB controller"
> -	depends on (USB || USB_GADGET) && ARCH_MSM
> +	tristate "Qualcomm on-chip USB OTG controller support"
> +	depends on (USB || USB_GADGET) && (ARCH_MSM || ARCH_QCOM)

I would actually drop USB || USB_GADGET dependency here just make it
easier to enable the driver on Kconfig, other you have to enable
USB_SUPPORT, then enable USB, go back one menu level, go down to PHY
menu, and choose this driver.

--=20
balbi

--451BZW+OUuJBCAYj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVoM9AAoJEIaOsuA1yqRE+t4P/2fAHxg1B9uVOnbW0MbUp/FT
bdO5ypa4+xKlpOfPXPnpByQsoA+xrAAEZO0I5MOwNqAeyLgIQ9ZGmZNQmqopVW9i
6GHM2hh7XGMq87DGHGDSyRXbmuqYboel5Uqo+7GetejYSILap7D2kSAgoiMTCgCB
/QT7DfXu8i0+PAuq4qs9gz+c3/F7oHd/O2xdXEWXgVPNJRMucRm9PO0NZgtjtozf
cuNn7yen4MwgFhhocszaQmUy2ZI/qY6WgF8GsY52yOXUDLuH2K3N0+D52AdTKrqJ
kuSaKavGxjKSJzxLI++NQqNvewTFDSOhtDcZpGT87NvsOzEiTPtj41c12LkJei+8
Up/q71XlTXOl087FUPoM0eDXBLTvKA5yUC1y8XMgnKz/dPa8rWehEbCMXiaWryk+
dmJLa06rMa/Ye9Z3d3Zm1oTtVBHQCdCzQBlfFCrcJVKT4o7MCN4IKqCfafgh3zH3
Vl2oRlpS8hlOgnp2fIq2ar08alCiJ0PqlbqVRZ+ZkRTolZPZ2UB3yFkO9QZIzeFr
VoTAsfhv0MEQ7zBeYvgH/JYBJhu46zPDXYSHPjNLnZfkG9WE1PmmrvNxB5AlMjun
2LOcwr5mCTGDX0lwvZB1WB/J0Dx5qGZHtKG8s3U353WkMlYCFTYSJwbj73MjKMx/
BX7DKkeI3R9VWNJNvrmv
=gH8M
-----END PGP SIGNATURE-----

--451BZW+OUuJBCAYj--
