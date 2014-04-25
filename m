Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaDYO4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:56:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57314 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaDYO4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:56:21 -0400
Date: Fri, 25 Apr 2014 09:55:39 -0500
From: Felipe Balbi <balbi@ti.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 01/18] usb: host: xhci-plat: Sort the headers in
 alphabetic order
Message-ID: <20140425145539.GB29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
 <1398434836-18908-2-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <1398434836-18908-2-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 04:06:59PM +0200, Gregory CLEMENT wrote:
> Sorting the headers in alphabetic order will help to reduce the conflict
> when adding new headers later.
>=20
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---

Acked-by: Felipe Balbi <balbi@ti.com>

>  drivers/usb/host/xhci-plat.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 151901ce1ba9..f5351af4b2c5 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -11,11 +11,11 @@
>   * version 2 as published by the Free Software Foundation.
>   */
> =20
> -#include <linux/platform_device.h>
> +#include <linux/dma-mapping.h>
>  #include <linux/module.h>
> -#include <linux/slab.h>
>  #include <linux/of.h>
> -#include <linux/dma-mapping.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> =20
>  #include "xhci.h"
> =20
> --=20
> 1.8.1.2
>=20

--=20
balbi

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWndrAAoJEIaOsuA1yqRE5jYP+gOv2Y9+XWWEULsDGw+xdL8s
1CXfrDkA2EMtCI1QFImA4M/v5Y/TpU8XqLsC14utltV/t5d9X24qNaveuS/IHWSp
aD7foenGz+3vIOdLTBMb7qYVnY53L+A7hrZMTTdKpl7olpidKfhgBe2IvQbhKOuG
veEm8yRgwmLaUsBvtAwhq1oIfDNz6CmY45giXQnT1j+leu1xA/JvotuMI8Gdp5Yd
H3QrPHe55FiaSZmAL2bnCd3ZRwN5Ad0za6cOWNXgKGmAo+pxlnOvESx6nvkJdgxt
wCIv5X15lDDXDy/PJFnZAOo7JmWx/fPXInDxgN6gqzSgBke15X1Suonw2rA6s4N/
Y8U+F4ASebPtLonO/XX64emqvsP6matd6MevMclNR0PZRcCDceZ19eo/alDcklZi
KL57kbsiqomHVScTXx2/phiuIlTUZsmEgQtqygYnw1IZiJMPqs+uizGx4/J7GFD5
aHz0XUzCKJCrZ+CHYOt2qixZK6AU0KkeIdb5Cs9RRFbjHeY8GXmwNm5Yp90OluYF
6PDkWBB+GXNiKtJskNaOPDiXwPO+0Iki6ha2y+m2mgMTrgD3hPdW3Kk9imnnl3La
42vrJ9QudnQ6CVYKGsXXEpI6T3vbG5zWDKp3wh0rvRH8Uwg8pFIOxWT+nMU8QzTd
NKp192yZoFdwYGULEsRx
=AAm3
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
