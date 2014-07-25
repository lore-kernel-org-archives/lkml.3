Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777AbaGYHtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:49:51 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60041 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaGYHtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:49:50 -0400
Message-ID: <53D20C19.5000306@monstr.eu>
Date: Fri, 25 Jul 2014 09:49:45 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Srikanth T <sthokal@xilinx.com>
Subject: Re: [PATCH v2 07/11] Documentation: devicetree: Fix Xilinx VDMA specification
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <1406242820-20140-8-git-send-email-afaerber@suse.de>
In-Reply-To: <1406242820-20140-8-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="6FkixWKDXrk6lh5imelucmhDsnrqsFdTe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6FkixWKDXrk6lh5imelucmhDsnrqsFdTe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

On 07/25/2014 01:00 AM, Andreas F=C3=A4rber wrote:
> The specification requires xlnx,data-width, but example and driver use
> xlnx,datawidth. Change the specification to match the implementation.
>=20
> Signed-off-by: Andreas F=C3=A4rber <afaerber@suse.de>
> ---
>  v2: New
> =20
>  Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.t=
xt b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> index 1405ed0..e4c4d47 100644
> --- a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> +++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> @@ -25,7 +25,7 @@ Required child node properties:
>  - compatible: It should be either "xlnx,axi-vdma-mm2s-channel" or
>  	"xlnx,axi-vdma-s2mm-channel".
>  - interrupts: Should contain per channel VDMA interrupts.
> -- xlnx,data-width: Should contain the stream data width, take values
> +- xlnx,datawidth: Should contain the stream data width, take values
>  	{32,64...1024}.
> =20
>  Optional child node properties:
>=20

Can you please take this patch through your tree?

Reviewed-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--6FkixWKDXrk6lh5imelucmhDsnrqsFdTe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPSDBkACgkQykllyylKDCGhOgCdH9m+jxhGj6jgOD0pSeMl0G0x
C/MAmwfpKpnZ7UldJlhohfjgJ4Mil976
=Kfag
-----END PGP SIGNATURE-----

--6FkixWKDXrk6lh5imelucmhDsnrqsFdTe--
