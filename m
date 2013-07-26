Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab3GZMWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:22:45 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:62814 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab3GZMWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:22:40 -0400
Message-ID: <51F26A0D.40302@monstr.eu>
Date: Fri, 26 Jul 2013 14:22:37 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: arnd@arndb.de, gregkh@linuxfoundation.org
CC: Srikanth Thokala <srikanth.thokala@xilinx.com>, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        grant.likely@linaro.org, Michal Simek <michal.simek@xilinx.com>,
        Srikanth Thokala <sthokal@xilinx.com>
Subject: Re: [LINUX PATCH RFC v2] trafgen: xilinx: add axi traffic generator
 driver
References: <477a2d56-a6f9-455f-b5c7-740ae9e9ba8e@CO1EHSMHS024.ehs.local>
In-Reply-To: <477a2d56-a6f9-455f-b5c7-740ae9e9ba8e@CO1EHSMHS024.ehs.local>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="SBtxg3PXtpPiecSBPAI8dSlKUT1hLrI3d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SBtxg3PXtpPiecSBPAI8dSlKUT1hLrI3d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Greg and Arnd,

On 07/20/2013 05:01 PM, Srikanth Thokala wrote:
> This is the driver for AXI Traffic Generator IP. The AXI
> Traffic Generator IP is a core that stresses the AXI4
> interconnect and other AXI4 peripherals in the system.
> It generates a wide variety of AXI4 transactions based on
> the core programming.
>=20
> Architecture of the core is broadly separated into a master
> and slave block, each of which contains the write block and
> read block. Other support functions are provided by the
> control registers and three internal RAMs - Master RAM,
> Command RAM, Parameter RAM. The initialisation sequence
> includes programming Command RAM with commands, data into
> Master RAM (optional Parameter RAM programming) and then
> enable master logic using control register interface.
> This sequence generates traffic to cores connected in the
> h/w design.
>=20
> The driver for this IP is designed to be a module with
> sysfs interface.  All the control registers and internal
> RAMs can be accessed through sysfs interface.
>=20
> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> v2: Documented sysfs functions

Do you have any concern about this patch?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--SBtxg3PXtpPiecSBPAI8dSlKUT1hLrI3d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHyag0ACgkQykllyylKDCHI0gCdFnD2oGgbQJa+edIN74pOcnRE
5JcAn1w1Q9kI7u/8jydL04I+C0/vj739
=6YRt
-----END PGP SIGNATURE-----

--SBtxg3PXtpPiecSBPAI8dSlKUT1hLrI3d--
