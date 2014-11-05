Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaKEFMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 00:12:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38134 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaKEFM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 00:12:28 -0500
Message-ID: <5459B1B5.6030001@suse.de>
Date: Wed, 05 Nov 2014 06:12:21 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-sh@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 5/7] pinctrl: Add driver for Zynq
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com> <1415041531-15520-6-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1415041531-15520-6-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="S2MwSV5cBp7sUvoUQdFQpFlhJscFQcQL0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S2MwSV5cBp7sUvoUQdFQpFlhJscFQcQL0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 03.11.2014 um 20:05 schrieb Soren Brinkmann:
> +enum zynq_pinmux_functions {
> +	ZYNQ_PMUX_ethernet0,
> +	ZYNQ_PMUX_ethernet1,
> +	ZYNQ_PMUX_mdio0,
> +	ZYNQ_PMUX_mdio1,
> +	ZYNQ_PMUX_qspi0,
> +	ZYNQ_PMUX_qspi1,
> +	ZYNQ_PMUX_qspi_fbclk,
> +	ZYNQ_PMUX_qspi_cs1,

Are usb0 and usb1 intentionally missing in this patch for lack of
upstream USB driver? If so, then please mention what you left out in the
commit message.

> +	ZYNQ_PMUX_spi0,
> +	ZYNQ_PMUX_spi1,
> +	ZYNQ_PMUX_sdio0,
> +	ZYNQ_PMUX_sdio0_pc,
> +	ZYNQ_PMUX_sdio0_cd,
> +	ZYNQ_PMUX_sdio0_wp,
> +	ZYNQ_PMUX_sdio1,
> +	ZYNQ_PMUX_sdio1_pc,
> +	ZYNQ_PMUX_sdio1_cd,
> +	ZYNQ_PMUX_sdio1_wp,
> +	ZYNQ_PMUX_smc0_nor,
> +	ZYNQ_PMUX_smc0_nor_cs1,
> +	ZYNQ_PMUX_smc0_nor_addr25,
> +	ZYNQ_PMUX_smc0_nand,
> +	ZYNQ_PMUX_can0,
> +	ZYNQ_PMUX_can1,
> +	ZYNQ_PMUX_uart0,
> +	ZYNQ_PMUX_uart1,
> +	ZYNQ_PMUX_i2c0,
> +	ZYNQ_PMUX_i2c1,
> +	ZYNQ_PMUX_ttc0,
> +	ZYNQ_PMUX_ttc1,
> +	ZYNQ_PMUX_swdt0,
> +	ZYNQ_PMUX_gpio0,
> +	ZYNQ_PMUX_MAX_FUNC
> +};

Regards,
Andreas

--=20
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=C3=B6rffer; HRB 21284 AG N=C3=BC=
rnberg


--S2MwSV5cBp7sUvoUQdFQpFlhJscFQcQL0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUWbG4AAoJEPou0S0+fgE/k3IP/2G9mKV1DAv79rXLpvRpVZGT
7bLEdueycjXL9ucbEWM1m/99wmJ3t7p4NcGvN3TH7Y74fc0vTmKe6gKLJLcVH6cP
dI+7dj2IqNOGYwXKEjLpDKFqyKzugbxe28r6zXywJdV+2w3nPv3bpfDJMwxVAXpA
oM8MnDX00vt/JU7XFUMBXNuyf3aFDzT85iyxRz7zx/zUypNgSJXrJE8aVdButg0s
DmPMFuh3Z5WiaX7MFGldmhl3lRFISpVt1DyF6Ocb4eqp0TFAV7sS+fLbIl40b1ry
l7/lt78S9M1K+o2Bop9egE2q8Kve8GuDc/Ic7+mjAvWCmoZcfFTCsi9S6DXte7bJ
O+iisd2t0KEiOp2B4DEQruhXVaJg3SJNswFqJu/S2KnL5dtcOyN3m0cv8Xvb2lbd
/SYc1zmvMxFg5HyU3E+f/K2YXzZ3dT3XgwsIDEfVXox0rIAMalGcX3suKKpFzXmV
hmp0pjzkXhRBxNtLFxXjduypYx9hO7kk9lm9NF+UlKr5GZv6w81xntXXET9PLisc
Ki0B3UesZv7pJ9JJd63rcoZnxXXjqqt1wnDS+IijpuiGtbYNvzv9C1vAmLZWUd4p
GcM3pv6OV+mC3iCneUvJ7akMMzOIrVT+8DpnnfYNQ/cF9fmjrgTND9QMzJK2sybT
JzhFkNQ2UvOWkwfzPrX/
=LTMe
-----END PGP SIGNATURE-----

--S2MwSV5cBp7sUvoUQdFQpFlhJscFQcQL0--
