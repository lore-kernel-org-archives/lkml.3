Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab3GZI11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:27:27 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:63941 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab3GZI1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:27:16 -0400
Message-ID: <51F232DB.6020806@monstr.eu>
Date: Fri, 26 Jul 2013 10:27:07 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] video: xilinxfb: Fix compilation warning
References: <b8701d73538d37495b41ef465440a6d5f3018870.1374759923.git.michal.simek@xilinx.com> <51F2262F.1020203@ti.com> <51F226C2.9000206@ti.com>
In-Reply-To: <51F226C2.9000206@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="PtkCQBRmbRFU5dS4wP2l7J8eTPOka7bev"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PtkCQBRmbRFU5dS4wP2l7J8eTPOka7bev
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/26/2013 09:35 AM, Tomi Valkeinen wrote:
> On 26/07/13 10:33, Tomi Valkeinen wrote:
>> On 25/07/13 16:45, Michal Simek wrote:
>>> regs_phys is phys_addr_t (u32 or u64).
>>> Lets use %pa printk format specifier.
>>>
>>> Fixes compilation warning introduced by:
>>> video: xilinxfb: Use drvdata->regs_phys instead of physaddr
>>> (sha1: c88fafef0135e1e1c3e23c3e32ccbeeabc587f81)
>>>
>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>=20
>> Thanks, I've applied this into my 3.12/fbdev branch.
>=20
> Actually, let's put this into 3.11-fixes/fbdev branch.
>=20

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--PtkCQBRmbRFU5dS4wP2l7J8eTPOka7bev
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHyMtsACgkQykllyylKDCHOGQCgnNJvhpUK1gbxSUMFi8+BJ6EU
wUoAn1sNszpqcgQl+2bLvT0Pu9SkGLaD
=rolO
-----END PGP SIGNATURE-----

--PtkCQBRmbRFU5dS4wP2l7J8eTPOka7bev--
