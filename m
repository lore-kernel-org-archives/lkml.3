Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaDCPAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:00:39 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57757 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbaDCPAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:00:35 -0400
Message-ID: <533D778D.8040002@monstr.eu>
Date: Thu, 03 Apr 2014 17:00:29 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        dougthompson@xmission.com, linux-edac@vger.kernel.org,
        michal.simek@xilinx.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sorenb@xilinx.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kpc528@gmail.com, kalluripunnaiahchoudary@gmail.com,
        punnaia@xilinx.com
Subject: Re: [RFC PATCH v2] edac: synopsys: Added EDAC support for zynq ddr
 ecc controller
References: <1220b715-6fc2-42ed-8393-b9859fc0deb9@TX2EHSMHS021.ehs.local>
In-Reply-To: <1220b715-6fc2-42ed-8393-b9859fc0deb9@TX2EHSMHS021.ehs.local>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VlsuwbUhon8iirSrhppR8nsr4O0PA4xRg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VlsuwbUhon8iirSrhppR8nsr4O0PA4xRg
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Borislav,

On 03/17/2014 06:23 AM, Punnaiah Choudary Kalluri wrote:
> Added EDAC support for reporting the ecc errors of synopsys ddr control=
ler.
> The ddr ecc controller corrects single bit errors and detects double bi=
t
> errors
>=20
> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
> ---
> Changes for v2:
> - Updated the commit header and message
> - Renamed the filenames to synopsys_edac
> - Corrected the compatilble string, commnets
> - Renamed the macros,fucntions and data structures
> ---
>  .../devicetree/bindings/edac/synopsys_edac.txt     |   18 +
>  drivers/edac/Kconfig                               |    7 +
>  drivers/edac/Makefile                              |    1 +
>  drivers/edac/synopsys_edac.c                       |  614 ++++++++++++=
++++++++
>  4 files changed, 640 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/edac/synopsys_eda=
c.txt
>  create mode 100644 drivers/edac/synopsys_edac.c

Do you have any comment about this driver?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--VlsuwbUhon8iirSrhppR8nsr4O0PA4xRg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM9d40ACgkQykllyylKDCGwhACfURAccx97+LNkJPV4UWF+Scm+
7DIAn02bFJvriyySNQtDnYybpkweJWJs
=y3tT
-----END PGP SIGNATURE-----

--VlsuwbUhon8iirSrhppR8nsr4O0PA4xRg--
