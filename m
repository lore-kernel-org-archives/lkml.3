Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab3GXHRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:17:37 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60116 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3GXHRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:17:36 -0400
Message-ID: <51EF7F8D.3070701@monstr.eu>
Date: Wed, 24 Jul 2013 09:17:33 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vivek Subbarao <vskerneldevel@gmail.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: xilinxfb: Fix compilation warning
References: <ed64cda456be840147ae1f04bec6a99733f41c24.1374643896.git.michal.simek@xilinx.com> <CAAY4GiVG-c63oJO1Kqv0Jf2Wa2Ba+hgLtHQYFqyuRW-f6hJ14Q@mail.gmail.com>
In-Reply-To: <CAAY4GiVG-c63oJO1Kqv0Jf2Wa2Ba+hgLtHQYFqyuRW-f6hJ14Q@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2OFWEDIIUNNEIWSAGQTSE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2OFWEDIIUNNEIWSAGQTSE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/24/2013 08:05 AM, Vivek Subbarao wrote:
> Why is there a necessity to type cast to unsigned long long ? Whats the=

> warning ?
>=20

Geerts: Build regressions/improvements in v3.11-rc2

  + drivers/video/xilinxfb.c: warning: format '%x' expects argument of ty=
pe 'unsigned int', but argument 4 has type 'phys_addr_t' [-Wformat]:  =3D=
> 344:3

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2OFWEDIIUNNEIWSAGQTSE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHvf40ACgkQykllyylKDCH75wCfXSH33j+eymnpyy8wMzkjOiyO
dDIAn3osgQ+au5pI/OPTweCo/lBpPZQf
=RiC7
-----END PGP SIGNATURE-----

------enig2OFWEDIIUNNEIWSAGQTSE--
