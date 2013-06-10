Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3FJJKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:10:32 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:53058 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3FJJKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:10:30 -0400
Message-ID: <51B59803.5090509@monstr.eu>
Date: Mon, 10 Jun 2013 11:10:27 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH v2 0/2] Xilinx watchdog changes
References: <cover.1369979787.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1369979787.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2VRAJDPJPSQFBXEKEPLEG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2VRAJDPJPSQFBXEKEPLEG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Wim

On 05/31/2013 07:56 AM, Michal Simek wrote:
> The patchset fixes license header and add 1.00.a IP to compatible
> list.
>=20
> Thanks for your review,
> Michal
>=20
> Remove the 3rd patch from this series which incorrectly
> tried to support set timeout feature.
>=20
> Changes in v2:
> - Extend compatible list with 1.00.a instead of replacing 1.01.a
>   reported by Guenter Roeck <linux@roeck-us.net>
>=20
> Michal Simek (2):
>   watchdog: xilinx: Fix driver header
>   watchdog: xilinx: Setup the origin compatible string
>=20
>  drivers/watchdog/of_xilinx_wdt.c | 31 +++++++++++--------------------
>  1 file changed, 11 insertions(+), 20 deletions(-)

Can you please add these two patches to your tree?

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2VRAJDPJPSQFBXEKEPLEG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlG1mAMACgkQykllyylKDCF3PACeOFcCKhnCdiYLAOgh7bf0fnvQ
aPsAniU1DSF91Gg3ilfZ9dn7gdigEGXS
=i93k
-----END PGP SIGNATURE-----

------enig2VRAJDPJPSQFBXEKEPLEG--
