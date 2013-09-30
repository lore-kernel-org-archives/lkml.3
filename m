Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3I3NZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:25:15 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36286 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3I3NZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:25:13 -0400
Message-ID: <52497BB6.9010506@monstr.eu>
Date: Mon, 30 Sep 2013 15:25:10 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 2/3] i2c: xilinx: Set tx direction in write operation
References: <c122ad49b27406ee495ef0d6cac191968d64f09f.1380532113.git.michal.simek@xilinx.com> <5d234cfc8d23cfc7e8d750f103344cf4e8e398d4.1380532113.git.michal.simek@xilinx.com> <20130930102242.GB3222@katana>
In-Reply-To: <20130930102242.GB3222@katana>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="LVMft17i8cMTajOqF02djctOrwOs5Prkj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LVMft17i8cMTajOqF02djctOrwOs5Prkj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/30/2013 12:22 PM, Wolfram Sang wrote:
> On Mon, Sep 30, 2013 at 11:08:51AM +0200, Michal Simek wrote:
>> From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
>>
>> In write operation, after filling address byte to tx fifo,
>> set the direction of transfer to tx using control register.
>=20
> You describe WHAT you do, yet you should describe WHY the change is
> needed. For example, I can't tell if this is an urgent bugfix or not.
> Please rephrase.
>=20

Will do.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--LVMft17i8cMTajOqF02djctOrwOs5Prkj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJJe7YACgkQykllyylKDCEx4QCeIMn0WEw5corMbnGHz0yzDoEJ
6L0AoJ34XT7biL3MKJnCXpqdtyh+IRdJ
=Hsaf
-----END PGP SIGNATURE-----

--LVMft17i8cMTajOqF02djctOrwOs5Prkj--
