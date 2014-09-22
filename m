Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaIVJhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:37:03 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:53970 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaIVJhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:37:00 -0400
Message-ID: <541FEDB5.7050305@monstr.eu>
Date: Mon, 22 Sep 2014 11:36:53 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>, Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: cadence: Remove .owner field for driver
References: <c076984af7e65c433fdfd3a3b0f8d20da2c18013.1407931005.git.michal.simek@xilinx.com> <20140920091106.GB1612@katana>
In-Reply-To: <20140920091106.GB1612@katana>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="aauvXf1ma3JD5wabEldwhj6hfVluxGjfV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aauvXf1ma3JD5wabEldwhj6hfVluxGjfV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/20/2014 11:11 AM, Wolfram Sang wrote:
> On Wed, Aug 13, 2014 at 01:56:51PM +0200, Michal Simek wrote:
>> There is no need to init .owner field.
>>
>> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
>> "mmc: remove .owner field for drivers using module_platform_driver"
								     ^
this shouldn't be there.

>>
>> This patch removes the superflous .owner field for drivers which
>=20
> It says drivers, but does only one...

I have c&p this from Peter's description that's why there are just driver=
s.

>=20
>> use the module_platform_driver API, as this is overriden in
>> platform_driver_register anyway."
>=20
> ... so: any interest in doing this for the whole subsystem? Basically
> good catch, though.

Mark was also interested about doing this for spi. Doing this for the who=
le
kernel will be the best. coccinelle script
is good option I have never played with it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--aauvXf1ma3JD5wabEldwhj6hfVluxGjfV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQf7bkACgkQykllyylKDCH8PACfaBXvXrmdurvKJ+74hpno1DCq
8eoAn201AIu82uVuVaL62q/jr0Nu1z+s
=bpbI
-----END PGP SIGNATURE-----

--aauvXf1ma3JD5wabEldwhj6hfVluxGjfV--
