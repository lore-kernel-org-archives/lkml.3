Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573AbaJaPX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:23:26 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53415 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200AbaJaPXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:23:25 -0400
Message-ID: <5453A961.6020900@monstr.eu>
Date: Fri, 31 Oct 2014 16:23:13 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Adrian McMenamin <lkmladrian@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Microblaze arch/microblaze/kernel/head.S: redundant code?
References: <CAN628AFYBxV-ynmQH9No+t+tVz9XnRkgybcpWXEuGj6FKqyBwA@mail.gmail.com>
In-Reply-To: <CAN628AFYBxV-ynmQH9No+t+tVz9XnRkgybcpWXEuGj6FKqyBwA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="GrdrvBijFCh80fnatvhWSIiufmMwDMBTh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GrdrvBijFCh80fnatvhWSIiufmMwDMBTh
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 10/31/2014 04:15 PM, Adrian McMenamin wrote:
> Looking at this code at line 78 (in 3.17 kernel) it has:
>=20
>     mfs r1, rmsr
>     msrclr r8, 0
>     cmpu r8, r8, r1
>=20
> But as far as I can see the result of that comparison is never used - t=
he
> comments state it is to test if the msrclr  instruction is enabled.

r8 is used when machine_early_init() is called.
r8 is 4th register which is used for passing args based on Microblaze
reference manual.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--GrdrvBijFCh80fnatvhWSIiufmMwDMBTh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlRTqWEACgkQykllyylKDCGXMwCeNGiTwIZVWhDGwLjRmb5OUlWb
B2sAn3H2MZuHSjx4xHgEynj+MWLEysAF
=FWKS
-----END PGP SIGNATURE-----

--GrdrvBijFCh80fnatvhWSIiufmMwDMBTh--
