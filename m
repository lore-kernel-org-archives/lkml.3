Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793AbaDVOKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:10:30 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62126 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745AbaDVOJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:09:59 -0400
Message-ID: <5356782A.9050809@monstr.eu>
Date: Tue, 22 Apr 2014 16:09:46 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        dhowells@redhat.com, broonie@linaro.org, benh@kernel.crashing.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 18/18] asm-generic: io: define relaxed accessor macros
 unconditionally
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com> <1397742261-15621-19-git-send-email-will.deacon@arm.com>
In-Reply-To: <1397742261-15621-19-git-send-email-will.deacon@arm.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="tiDH4Mqrch3wXrvoNuUH4amjGcTWUvO9I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tiDH4Mqrch3wXrvoNuUH4amjGcTWUvO9I
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/17/2014 03:44 PM, Will Deacon wrote:
> Now that no architectures using asm-generic/io.h define their own relax=
ed
> accessors, the dummy definitions can be used unconditionally.
>=20
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  include/asm-generic/io.h | 18 ------------------
>  1 file changed, 18 deletions(-)

Do we need this? I think there could be a need to overwrite them.
Currently we are just lucky that architecture which uses asm-generic/io.h=

don't need to overwrite it.
But I expect that all archs should use asm-generic/io.h to clean
architecture io.h exactly I have done it for Microblaze.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--tiDH4Mqrch3wXrvoNuUH4amjGcTWUvO9I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNWeCoACgkQykllyylKDCHL7QCfZHY0AEPJpupieO3TTKRh9VXj
VN4AnRtRl3pIh5H8pVJrJxaX+V08i19U
=7Mr8
-----END PGP SIGNATURE-----

--tiDH4Mqrch3wXrvoNuUH4amjGcTWUvO9I--
