Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaDCN5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:57:05 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33862 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaDCN5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:57:02 -0400
Message-ID: <533D68A1.6070102@monstr.eu>
Date: Thu, 03 Apr 2014 15:56:49 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: computersforpeace@gmail.com
CC: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        michal.simek@xilinx.com, grant.likely@linaro.org,
        gregkh@linuxfoundation.org, jason@lakedaemon.net,
        ezequiel.garcia@free-electrons.com, arnd@arndb.de, dwmw2@infradead.org,
        artem.bityutskiy@linux.intel.com, pekon@ti.com, jussi.kivilinna@iki.fi,
        acourbot@nvidia.com, ivan.khoronzhuk@ti.com, joern@logfs.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        kpc528@gmail.com, kalluripunnaiahchoudary@gmail.com,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 3/3] nand: pl353: Add driver for arm pl353 smc nand
 interface
References: <1395944467-26291-1-git-send-email-punnaia@xilinx.com> <04cb5d02-db4c-4a4c-ba3c-3a5958e42324@VA3EHSMHS036.ehs.local>
In-Reply-To: <04cb5d02-db4c-4a4c-ba3c-3a5958e42324@VA3EHSMHS036.ehs.local>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="wNmTf5oGp60PINlQ7Mov8xBRJllfwN39A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wNmTf5oGp60PINlQ7Mov8xBRJllfwN39A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Brian,

On 03/27/2014 07:21 PM, Punnaiah Choudary Kalluri wrote:
> Add driver for arm pl353 static memory controller nand interface.
> This controller is used in xilinx zynq soc for interfacing the nand
> flash memory.
>=20
> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
> ---
>  drivers/mtd/nand/Kconfig      |    8 +
>  drivers/mtd/nand/Makefile     |    1 +
>  drivers/mtd/nand/pl353_nand.c | 1122 +++++++++++++++++++++++++++++++++=
++++++++
>  3 files changed, 1131 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mtd/nand/pl353_nand.c

Any comment regarding this nand driver?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--wNmTf5oGp60PINlQ7Mov8xBRJllfwN39A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM9aKIACgkQykllyylKDCHaWACfQ/Zi698CjnU+NJ1GQGCGgrKc
1QUAniHOKY9OrXWLKdIISa/6Fv3NbCgh
=rfBT
-----END PGP SIGNATURE-----

--wNmTf5oGp60PINlQ7Mov8xBRJllfwN39A--
