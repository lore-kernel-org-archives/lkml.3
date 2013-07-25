Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3GYNn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:43:57 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:50464 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab3GYNnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:43:53 -0400
Message-ID: <51F12B91.4010303@monstr.eu>
Date: Thu, 25 Jul 2013 15:43:45 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] video: xilinxfb: Fix compilation warning
References: <204d93f8a9dffef6ff00d961f91be0b465f21841.1374751310.git.michal.simek@xilinx.com> <CAMuHMdX2mKANduZO9HaBHRZ13V0PztOc-uYxTymUsH8-NE5FEQ@mail.gmail.com>
In-Reply-To: <CAMuHMdX2mKANduZO9HaBHRZ13V0PztOc-uYxTymUsH8-NE5FEQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bsbIoiPehSIJfpXVhMAsAXBxEA7NUSamd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bsbIoiPehSIJfpXVhMAsAXBxEA7NUSamd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/25/2013 03:36 PM, Geert Uytterhoeven wrote:
> On Thu, Jul 25, 2013 at 1:21 PM, Michal Simek <michal.simek@xilinx.com>=
 wrote:
>> regs_phys is phys_addr_t (u32 or u64).
>> Lets retype it to u64.
>=20
> This no longer matches the actual patch?

I need some holidays.

Will send v3.

Sorry,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--bsbIoiPehSIJfpXVhMAsAXBxEA7NUSamd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHxK5EACgkQykllyylKDCGxoACfW6HQQri8K3P6jDKV1FFi6pcM
nf4An0c1VDuj8xgxuCAADXigcHtMoS0S
=P5d8
-----END PGP SIGNATURE-----

--bsbIoiPehSIJfpXVhMAsAXBxEA7NUSamd--
