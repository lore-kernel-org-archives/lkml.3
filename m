Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3E3MdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:33:03 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:49210 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3E3Mc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:32:56 -0400
Message-ID: <51A746F3.5030503@monstr.eu>
Date: Thu, 30 May 2013 14:32:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 1/3] watchdog: xilinx: Fix driver header
References: <b565740967bfa3b3fa867442634f524000c097f8.1369916757.git.michal.simek@xilinx.com> <D958900912E20642BCBC71664EFECE3E6E51FD29A4@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6E51FD29A4@BGMAIL02.nvidia.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2QLVHUFWQVGIVDXVXHECT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2QLVHUFWQVGIVDXVXHECT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/30/2013 02:30 PM, Venu Byravarasu wrote:
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Michal Simek
>> Sent: Thursday, May 30, 2013 5:56 PM
>> To: linux-kernel@vger.kernel.org
>> Cc: Michal Simek; Michal Simek; Wim Van Sebroeck; linux-
>> watchdog@vger.kernel.org
>> Subject: [PATCH 1/3] watchdog: xilinx: Fix driver header
>>
>> * PGP Signed by an unknown key
>>
>> - Remove reference for IP version
>> - Fix header coding style
>> - Remove notes which are visible from the code
>> - Fix driver license according to header
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>  drivers/watchdog/of_xilinx_wdt.c | 30 ++++++++++--------------------
>>  1 file changed, 10 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/watchdog/of_xilinx_wdt.c
>> b/drivers/watchdog/of_xilinx_wdt.c
>> index 2761ddb..d4a35ab 100644
>> --- a/drivers/watchdog/of_xilinx_wdt.c
>> +++ b/drivers/watchdog/of_xilinx_wdt.c
>> @@ -1,23 +1,13 @@
>>  /*
>> -*   of_xilinx_wdt.c  1.01  A Watchdog Device Driver for Xilinx
>> xps_timebase_wdt
>> -*
>> -*   (C) Copyright 2011 (Alejandro Cabrera <aldaya@gmail.com>)
>> -*
>> -*       -----------------------
>> -*/
>> + * Watchdog Device Driver for Xilinx axi/xps_timebase_wdt
>> + *
>> + * (C) Copyright 2011 (Alejandro Cabrera <aldaya@gmail.com>)
>=20
> Should year not be updated?=20

This is just header fixup.
I think he is not working/maintaining this driver for a long time.
I would write there Xilinx copyright but I really don't care.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2QLVHUFWQVGIVDXVXHECT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGnRvMACgkQykllyylKDCEWfACfYvsjyJjXWj+xJDAfEPilTzf5
gpkAn2dVpK616nXcUJWG+UhBsTTELF8C
=OvZD
-----END PGP SIGNATURE-----

------enig2QLVHUFWQVGIVDXVXHECT--
