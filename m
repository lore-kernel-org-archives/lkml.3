Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbaLBLmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:42:19 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37012 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaLBLmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:42:17 -0500
Message-ID: <547DA592.7090900@monstr.eu>
Date: Tue, 02 Dec 2014 12:42:10 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Dubov <alex.dubov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] fs: Wire up sendfd() syscall (all architectures)
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>	<1417494919-4577-3-git-send-email-oakad@yahoo.com> <CAMuHMdWWnO7m8f+NnM8Xahexc+3ELeAgTDv67CzWWEZENqztEA@mail.gmail.com>
In-Reply-To: <CAMuHMdWWnO7m8f+NnM8Xahexc+3ELeAgTDv67CzWWEZENqztEA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4qDN9JJU6eUeG0wWbksSXGiD7JjuaJsiA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4qDN9JJU6eUeG0wWbksSXGiD7JjuaJsiA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/02/2014 09:01 AM, Geert Uytterhoeven wrote:
> This really needs a CC to linux-arch (added).
>=20
> On Tue, Dec 2, 2014 at 5:35 AM, Alex Dubov <alex.dubov@gmail.com> wrote=
:
>> Signed-off-by: Alex Dubov <oakad@yahoo.com>
>> ---
>>  arch/arm/include/uapi/asm/unistd.h        |  1 +
>>  arch/arm/kernel/calls.S                   |  1 +
>>  arch/arm64/include/asm/unistd32.h         |  2 ++
>>  arch/ia64/include/uapi/asm/unistd.h       |  1 +
>>  arch/ia64/kernel/entry.S                  |  1 +
>>  arch/m68k/include/uapi/asm/unistd.h       |  1 +
>>  arch/m68k/kernel/syscalltable.S           |  1 +
>=20
> You forgot to update NR_syscalls in arch/m68k/include/asm/unistd.h.
>=20
>>  arch/microblaze/include/uapi/asm/unistd.h |  1 +
>>  arch/microblaze/kernel/syscall_table.S    |  1 +


The same for microblaze here
arch/microblaze/include/asm/unistd.h

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--4qDN9JJU6eUeG0wWbksSXGiD7JjuaJsiA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlR9pZUACgkQykllyylKDCGWqgCaArzsmCs53eX6oPJmj3ttGGaQ
5gkAn30WVj1HtleR4nHHGO0XJyoaqKPw
=7OJW
-----END PGP SIGNATURE-----

--4qDN9JJU6eUeG0wWbksSXGiD7JjuaJsiA--
