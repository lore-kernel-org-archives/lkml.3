Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161950AbaKNVIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:08:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60956 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbaKNVIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:08:47 -0500
Date: Fri, 14 Nov 2014 15:08:32 -0600
From: Felipe Balbi <balbi@ti.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <Peter.Chen@freescale.com>,
        <balbi@ti.com>, <p.zabel@pengutronix.de>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 08/13] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20141114210832.GE16388@saruman>
Reply-To: <balbi@ti.com>
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com>
 <1415978763-27345-9-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7LkOrbQMr4cezO2T"
Content-Disposition: inline
In-Reply-To: <1415978763-27345-9-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7LkOrbQMr4cezO2T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 04:25:58PM +0100, Antoine Tenart wrote:
> Add a USB2 ChipIdea driver for ci13xxx, with optional PHY, clock
> and DMA mask, to support USB2 ChipIdea controllers that don't need
> specific functions.
>=20
> Tested on the Marvell Berlin SoCs USB controllers.
>=20
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/Makefile       |   1 +
>  drivers/usb/chipidea/ci_hdrc_usb2.c | 117 ++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 118 insertions(+)
>  create mode 100644 drivers/usb/chipidea/ci_hdrc_usb2.c
>=20
> diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
> index 2f099c7df7b5..1fc86a2ca22d 100644
> --- a/drivers/usb/chipidea/Makefile
> +++ b/drivers/usb/chipidea/Makefile
> @@ -10,6 +10,7 @@ ci_hdrc-$(CONFIG_USB_OTG_FSM)		+=3D otg_fsm.o
> =20
>  # Glue/Bridge layers go here
> =20
> +obj-$(CONFIG_USB_CHIPIDEA)	+=3D ci_hdrc_usb2.o

usb2 is too generic, you should call it ci_hdcr_marvell, or something
like that.

--=20
balbi

--7LkOrbQMr4cezO2T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZm9QAAoJEIaOsuA1yqREWHwP/A9omNZxdGijpfNCN8z2PaHC
A7Li0HF/a87E29/5S2vh1yDihIJQJY5txGX50dSxmiWZ7ZjGQPV2rMxM/xo2uEkF
3qDKhzW5qreVziqwPIOZq3jujf2o9F1fd8v1Ao6xCB7hBOEetHYSgkXPw5jKQLuz
PVsEuN5c5fb1s6FNxjIL8aqqdWC1O/ft/bM4gF6Cb/Ep+c10aV3bDrI6YOLZ9MaP
t0m5I+LiWcZFL+UxW3Me4bfcWbEMwur3M9f3nrCQcWrA5b83afymEQL9/Y1I3vHB
9MgplH7TYQlyuD2zQdCDqAnuHP43Zh2Y4L+qQqQlX7ftn98j64pIrA8E6yuW3+3u
bfei9+7qoHlzqZBd72PJq8JuBh71EknYcDbhjTB8hmsemfoqsuQrG0N+s6IiZw0F
md+HJfMTWsjUUyk6DV4uG91hhiKB+BRMlPLFYn1gvI5CqStPpOvbLnM/aMbiMRom
S4ZhCUzpRChzL7hegISkYxgsDAoheZ6T3xll2v9rnaZ6fx/zmAsREngAAyJHH7rE
u77poV4dYhnejj1hLeZDXNfqpWyvcy6BbvuKvUeOxDNWAQ8ruUJFcShR/pOx/M9i
9Xc+a31EQU84aPXPPYR7hZhKE2U1zoUq+4/2rJ6qi734L0AipSXVE0PuqU6r51+o
IZRBXa5TEWj87QWaFqj4
=YA/Z
-----END PGP SIGNATURE-----

--7LkOrbQMr4cezO2T--
