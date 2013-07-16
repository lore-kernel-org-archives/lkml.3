Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab3GPJrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:47:25 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59403 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3GPJrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:47:24 -0400
Message-ID: <51E516A9.9090705@monstr.eu>
Date: Tue, 16 Jul 2013 11:47:21 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.11-rc1
References: <alpine.DEB.2.02.1307160950110.8862@ayla.of.borg> <51E50D24.8030900@monstr.eu> <CAMuHMdWyr_GzDzGBoYn3T85Dqe65FCKd0Y_xvEwwS6UY7naPXQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWyr_GzDzGBoYn3T85Dqe65FCKd0Y_xvEwwS6UY7naPXQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2GSWWVHKUTTDDJSDLDHJA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2GSWWVHKUTTDDJSDLDHJA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/16/2013 11:29 AM, Geert Uytterhoeven wrote:
> On Tue, Jul 16, 2013 at 11:06 AM, Michal Simek <monstr@monstr.eu> wrote=
:
>> On 07/16/2013 09:50 AM, Geert Uytterhoeven wrote:
>>>   + drivers/spi/spi-xilinx.c: error: implicit declaration of function=
 'ioread32' [-Werror=3Dimplicit-function-declaration]:  =3D> 105:2
>>>   + drivers/spi/spi-xilinx.c: error: implicit declaration of function=
 'ioread32be' [-Werror=3Dimplicit-function-declaration]:  =3D> 115:2
>>>   + drivers/spi/spi-xilinx.c: error: implicit declaration of function=
 'iowrite32' [-Werror=3Dimplicit-function-declaration]:  =3D> 100:2
>>>   + drivers/spi/spi-xilinx.c: error: implicit declaration of function=
 'iowrite32be' [-Werror=3Dimplicit-function-declaration]:  =3D> 110:2
>=20
> cris-allyesconfig/cris-allmodconfig, so this can be safely ignored (by =
you ;-)

Partially because it is my change which is causing these warnings but all=
 architectures
should have these common io functions.

>>>   + drivers/video/xilinxfb.c: warning: format '%x' expects argument o=
f type 'unsigned int', but argument 4 has type 'phys_addr_t' [-Wformat]: =
 =3D> 344:3
>=20
> ppc44x_defconfig

ok. Will fix this.

>> How to find out which target is causing these warnings?
>=20
> It's indeed a bit difficult without the full logs. /me needs to study k=
up.

ok.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2GSWWVHKUTTDDJSDLDHJA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHlFqoACgkQykllyylKDCEs1QCeNpuwZ4A6MI4CjrkqH2XBNGVa
YQ4AoItuenJJMIzryepSS869D5cCHH44
=VAc0
-----END PGP SIGNATURE-----

------enig2GSWWVHKUTTDDJSDLDHJA--
