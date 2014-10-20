Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaJTTIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:08:31 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57017 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaJTTHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:07:07 -0400
Message-ID: <54455D55.6030003@monstr.eu>
Date: Mon, 20 Oct 2014 21:07:01 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v2 1/3] ARM: zynq: Move common.h to generic location
References: <742a19eb987f3f99b42ba4b7e7ebc27bf19d7d72.1413811526.git.michal.simek@xilinx.com> <3225036.9QQDRKvzZS@wuerfel>
In-Reply-To: <3225036.9QQDRKvzZS@wuerfel>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="vqpllCpkx3K9iVkw9uwjQFFMhose05C28"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vqpllCpkx3K9iVkw9uwjQFFMhose05C28
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/20/2014 03:36 PM, Arnd Bergmann wrote:
> On Monday 20 October 2014 15:25:31 Michal Simek wrote:
>> include/soc/zynq/ is the right location for this header
>> to be able to share information from this header with other
>> drivers which require it.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>> Changes in v2:
>> - Update pm.c added in 3.17 too - Soren pointed on it
>>
>>  arch/arm/mach-zynq/common.c                       |  2 +-
>>  arch/arm/mach-zynq/hotplug.c                      | 14 --------------=

>>  arch/arm/mach-zynq/platsmp.c                      |  2 +-
>>  arch/arm/mach-zynq/pm.c                           |  2 +-
>>  arch/arm/mach-zynq/slcr.c                         |  2 +-
>>  {arch/arm/mach-zynq =3D> include/soc/zynq}/common.h |  0
>>  6 files changed, 4 insertions(+), 18 deletions(-)
>>  delete mode 100644 arch/arm/mach-zynq/hotplug.c
>>  rename {arch/arm/mach-zynq =3D> include/soc/zynq}/common.h (100%)
>>
>=20
> NAK
>=20
> Most (if not all) of that header should not be visible to drivers.
> If you need to share some symbols, make a proper header file for those,=

> not one called 'common.h'.

Ok. I will split it to more files - no problem to do it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--vqpllCpkx3K9iVkw9uwjQFFMhose05C28
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlRFXVYACgkQykllyylKDCErPwCeKV6FCUooxcucrkZoOXftD5ah
DdkAoJV21aafW7oXnTZcYRfTLH+HdMap
=NYL1
-----END PGP SIGNATURE-----

--vqpllCpkx3K9iVkw9uwjQFFMhose05C28--
