Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965041AbaD3QXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:23:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33034 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759198AbaD3QX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:23:27 -0400
Date: Wed, 30 Apr 2014 11:22:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>, <linux-arm-msm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Manu Gautam <mgautam@codeaurora.org>
Subject: Re: [PATCH v8 14/20] usb: phy: msm: Add support for secondary PHY
 control
Message-ID: <20140430162228.GI23679@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
 <1398692063-11372-15-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zgY/UHCnsaNnNXRx"
Content-Disposition: inline
In-Reply-To: <1398692063-11372-15-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zgY/UHCnsaNnNXRx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 28, 2014 at 04:34:17PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> Allow support to use 2nd HSPHY with USB2 Core.
> Some platforms may have configuration to allow USB controller
> work with any of the two HSPHYs present. By default driver
> configures USB core to use primary HSPHY. Add support to allow
> user select 2nd HSPHY using DT parameter.
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Cc: Manu Gautam <mgautam@codeaurora.org>
> ---
>  .../devicetree/bindings/usb/msm-hsusb.txt          |  6 ++++++
>  drivers/usb/phy/phy-msm-usb.c                      | 24 ++++++++++++++++=
++++--
>  include/linux/usb/msm_hsusb.h                      |  1 +
>  include/linux/usb/msm_hsusb_hw.h                   |  1 +
>  4 files changed, 30 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Docume=
ntation/devicetree/bindings/usb/msm-hsusb.txt
> index ee4123d..0669667 100644
> --- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> +++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> @@ -59,6 +59,12 @@ Optional properties:
>                  For example: qcom,phy-init-sequence =3D < -1 0x63 >;
>                  Will update only value at address ULPI_EXT_VENDOR_SPECIF=
IC + 1.
>=20
> +- qcom,phy-num: Select number of pyco-phy to use, can be one of
> +                0 - PHY one, default
> +                1 - Second PHY
> +                Some platforms may have configuration to allow USB
> +                controller work with any of the two HSPHYs present.

I have a feeling there's a better to do this with of alias. But it would
be good if Kumar or any of the DT folks could pitch in.

--=20
balbi

--zgY/UHCnsaNnNXRx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYSNEAAoJEIaOsuA1yqREa7UP/1hkv/H5lWCm+Ys3nG+0zdlm
6axlzhDEs0MPpFm7T1wfaDv21EDtMVb0ugBeUxTIVJBWDW7gV4g3QSvvauok7tJ1
IpLgubZSf168WZZiFRTCXAnVPvXXf/ct1p0ClRNVkMnldQiWheNpy/2Ly9G0DaH7
/Jk3hFcr543dpsaYw0kKYLT1JKrumXKPCAOtekpTeYSBbHuBNF0o1WLVxPNGHxhy
oMNWj6Gs81iGVLJrSr6iVgVeQKZhDJFSZOMveKupKnJXoI1b2+Ez7bibjbLx7FHT
Efr4mt/wc4ktKDAbLKXghhA7+76XQfNCs5FlcA+rLYVOjtBAH63W+QfgJwp/Yh9b
Omgh/duXGNAVgwmjwVE/XHQYptJ29rsRkWsJwS6z1yOYtBaonXeb4Y3+uLFQ1AFX
J46wxdAkaoojTJ4b5qw7RVYgJT/MFbldWSSEGoefgIbj7/lFCGSNbqJwY5oXiwAz
GfgGtHzdGXEziGR53KZfr2OZMiXceRlDOYy5kDxOjH7Q6KWOomt+Upd1ZqUmmqWm
JpoHE+bGT9TpPlt17VifaVZsmUlnvmcqxy/7sQ1k4K1dyEeo9PTO/2D9+9pFj0AA
MFXtGP16MoAqRzWfLc5oVSdyvGONSgGtIcwx6SGFm/JV8wcEuDEzAGub64tkT08W
7FSF4Ee6Vw9EpWFM8ltT
=ATDK
-----END PGP SIGNATURE-----

--zgY/UHCnsaNnNXRx--
