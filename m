Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3KKJN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:13:26 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58989 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3KKJNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:13:17 -0500
Message-ID: <52809FAA.6080107@monstr.eu>
Date: Mon, 11 Nov 2013 10:13:14 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Subject: Re: [PATCH] video: add OpenCores VGA/LCD framebuffer driver
References: <1384088894-31920-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-Reply-To: <1384088894-31920-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="OLhXCKXbs0SMrE2iChrr3kaGbG1NjjIIe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OLhXCKXbs0SMrE2iChrr3kaGbG1NjjIIe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/10/2013 02:08 PM, Stefan Kristiansson wrote:
> This adds support for the VGA/LCD core available from OpenCores:
> http://opencores.org/project,vga_lcd
>=20
> The driver have been tested together with both OpenRISC and
> ARM (socfpga) processors.
>=20
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> ---
>  drivers/video/Kconfig  |  17 ++
>  drivers/video/Makefile |   1 +
>  drivers/video/ocfb.c   | 479 +++++++++++++++++++++++++++++++++++++++++=
++++++++
>  3 files changed, 497 insertions(+)
>  create mode 100644 drivers/video/ocfb.c
>=20
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 84b685f..2ea850c 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -979,6 +979,23 @@ config FB_PVR2
>  	  (<file:drivers/video/pvr2fb.c>). Please see the file
>  	  <file:Documentation/fb/pvr2fb.txt>.
> =20
> +config FB_OPENCORES
> +	tristate "OpenCores VGA/LCD core 2.0 framebuffer support"
> +	depends on FB
> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
> +	default n
> +	help
> +	  This enables support for the OpenCores VGA/LCD core.
> +
> +	  The OpenCores VGA/LCD core is typically used together with
> +	  softcore CPUs (e.g. OpenRISC) or hard processor systems

I expect that here can be also Microblaze.

> +	  (e.g. Altera socfpga or Xilinx Zync) on FPGAs.

s/Zync/Zynq/

M




--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--OLhXCKXbs0SMrE2iChrr3kaGbG1NjjIIe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKAn6oACgkQykllyylKDCGxvgCfR0Uo95dUsgJR6505BAC+/WYD
m9MAoJJV5YSZD1zuePPIkH0EVtm35px3
=608F
-----END PGP SIGNATURE-----

--OLhXCKXbs0SMrE2iChrr3kaGbG1NjjIIe--
