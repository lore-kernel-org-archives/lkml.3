Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbaGYIBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:01:39 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:37478 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022AbaGYIBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:01:38 -0400
Message-ID: <53D20EDD.9040206@monstr.eu>
Date: Fri, 25 Jul 2014 10:01:33 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Michal Simek <michal.simek@xilinx.com>
CC: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 01/11] Documentation: devicetree: Adapteva vendor prefix
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <1406242820-20140-2-git-send-email-afaerber@suse.de>
In-Reply-To: <1406242820-20140-2-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="EX0gLVfeSQTNTxW4NRJukveg2n5VAe72g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EX0gLVfeSQTNTxW4NRJukveg2n5VAe72g
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/25/2014 01:00 AM, Andreas F=C3=A4rber wrote:
> Cc: Andreas Olofsson <andreas@adapteva.com>
> Signed-off-by: Andreas F=C3=A4rber <afaerber@suse.de>
> ---
>  v2: New
> =20
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Do=
cumentation/devicetree/bindings/vendor-prefixes.txt
> index 46a311e..a8708c7 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -6,6 +6,7 @@ using them to avoid name-space collisions.
>  abilis	Abilis Systems
>  active-semi	Active-Semi International Inc
>  ad	Avionic Design GmbH
> +adapteva	Adapteva, Inc.
>  adi	Analog Devices, Inc.
>  aeroflexgaisler	Aeroflex Gaisler AB
>  ak	Asahi Kasei Corp.
>=20

Applied zynq/dt branch.
https://github.com/Xilinx/linux-xlnx/commits/zynq/dt

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--EX0gLVfeSQTNTxW4NRJukveg2n5VAe72g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPSDt0ACgkQykllyylKDCGNAwCfWnqMoS3QFVoA29Z1phZ6iWk0
2rkAoJfwvrEFPB/dC7WL0n2Br6zfw8If
=wtO2
-----END PGP SIGNATURE-----

--EX0gLVfeSQTNTxW4NRJukveg2n5VAe72g--
