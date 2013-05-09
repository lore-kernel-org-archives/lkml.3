Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3EIG4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 02:56:01 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:52621 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3EIGz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 02:55:59 -0400
Message-ID: <518B4875.9000303@monstr.eu>
Date: Thu, 09 May 2013 08:55:49 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the microblaze tree with Linus' tree
References: <20130509103513.8432fb1f7834a57de404f2a7@canb.auug.org.au>
In-Reply-To: <20130509103513.8432fb1f7834a57de404f2a7@canb.auug.org.au>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2XWBFHJWVVDCCRNGFUSHJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2XWBFHJWVVDCCRNGFUSHJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Stephen

On 05/09/2013 02:35 AM, Stephen Rothwell wrote:
> Hi Michal,
>=20
> Today's linux-next merge of the microblaze tree got a conflict in
> arch/microblaze/mm/init.c between commit 7beb5987875b ("mm/microblaze:
> use common help functions to free reserved pages") from Linus' tree and=

> commits 17408c87ba9e ("microblaze: Fix free_init_pages function") and
> c5c09c08718b ("microblaze: Fix initrd support") from the microblaze tre=
e.
>=20
> I just used the version from Linus' tree (I am not sure if that is the
> correct solution) and can carry the fix as necessary (no action is
> required).

Thanks for reporting this. I will look at it and fix it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2XWBFHJWVVDCCRNGFUSHJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGLSHUACgkQykllyylKDCE4YwCeLeUI5f7LxzmUDpV+10ihRYFP
DHIAoI10tcvnGXjRIPnhlTj4+iYW+53v
=PbKd
-----END PGP SIGNATURE-----

------enig2XWBFHJWVVDCCRNGFUSHJ--
