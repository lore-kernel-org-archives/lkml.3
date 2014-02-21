Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaBUGi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 01:38:27 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:52085 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaBUGiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 01:38:24 -0500
Message-ID: <5306F458.9010706@monstr.eu>
Date: Fri, 21 Feb 2014 07:38:16 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: balbi@ti.com
CC: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local> <20140220182257.GF23217@saruman.home>
In-Reply-To: <20140220182257.GF23217@saruman.home>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Oqx0dPQ6Ek1O2VkS9NggUWs20Qa7cBUuj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Oqx0dPQ6Ek1O2VkS9NggUWs20Qa7cBUuj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

>> + * Copyright (C) 2010 - 2014 Xilinx, Inc.
>> + *
>> + * Some parts of this driver code is based on the driver for at91-ser=
ies
>> + * USB peripheral controller (at91_udc.c).
>> + *
>> + * This program is free software; you can redistribute it
>> + * and/or modify it under the terms of the GNU General Public
>> + * License as published by the Free Software Foundation;
>> + * either version 2 of the License, or (at your option) any
>> + * later version.
>=20
> are you sure you want to allow people ot use GPL v3 on this driver ?

The license is the same as is in at91_udc.c driver.
=46rom my understanding if this driver is based on that one we
have to follow license from it.
And this is problem in general with all licenses in the kernel
which use this fragment.
I don't think we can change it to be just GPLv2.
Please correct me if I am wrong.

BTW: u-boot started to use SPDX-License-Identifier
which will be nice to start to use.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--Oqx0dPQ6Ek1O2VkS9NggUWs20Qa7cBUuj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMG9FgACgkQykllyylKDCElSwCfa6Xi7L+AFzYxGfNPH+eQYMTs
2AQAnjZoDi/eyZ71fksfsfQURIrulpG3
=j2AP
-----END PGP SIGNATURE-----

--Oqx0dPQ6Ek1O2VkS9NggUWs20Qa7cBUuj--
