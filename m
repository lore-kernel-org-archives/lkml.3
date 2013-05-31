Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3EaNJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 09:09:14 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:48252 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3EaNJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 09:09:10 -0400
Message-ID: <51A8A0ED.8090006@monstr.eu>
Date: Fri, 31 May 2013 15:09:01 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Timur Tabi <timur@tabi.org>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3 1/8] video: xilinxfb: Fix OF probing on little-endian
 systems
References: <cover.1370004925.git.michal.simek@xilinx.com> <0a546c3de84c4650d019274debef0ded9007b36f.1370004925.git.michal.simek@xilinx.com> <51A8A016.3000306@tabi.org>
In-Reply-To: <51A8A016.3000306@tabi.org>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2COALSFKQSHUSOCLLVCQF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2COALSFKQSHUSOCLLVCQF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/31/2013 03:05 PM, Timur Tabi wrote:
> On 05/31/2013 07:55 AM, Michal Simek wrote:
>> -	p =3D (u32 *)of_get_property(op->dev.of_node, "xlnx,dcr-splb-slave-i=
f", NULL);
>> -	tft_access =3D p ? *p : 0;
>> +	of_property_read_u32(op->dev.of_node, "xlnx,dcr-splb-slave-if",
>> +			     &tft_access);
>=20
> This is okay, but just FYI, you could instead have just used be32_to_cp=
up().

yep. I was there in v1 but then Soren suggested to use of_property_read_u=
32
http://lkml.org/lkml/2013/5/29/365

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2COALSFKQSHUSOCLLVCQF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGooO0ACgkQykllyylKDCFm6QCfcErRgHArTC4UtNG0FXRvG0eu
tjoAnjN4rqVV65w6mQvRKiC0wJs3csAT
=sghZ
-----END PGP SIGNATURE-----

------enig2COALSFKQSHUSOCLLVCQF--
