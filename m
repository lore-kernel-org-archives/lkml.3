Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaBRQKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:10:13 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:45331 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbaBRQKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:10:11 -0500
Message-ID: <530385D9.5090005@monstr.eu>
Date: Tue, 18 Feb 2014 17:10:01 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        achew@nvidia.com
Subject: Re: [PATCH v2] microblaze: Rename global function heartbeat()
References: <1392706014-23332-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1392706014-23332-1-git-send-email-linux@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="mPK4nQLnLq7a8k856VuQ4E3khKjMRAkf9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mPK4nQLnLq7a8k856VuQ4E3khKjMRAkf9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/18/2014 07:46 AM, Guenter Roeck wrote:
> microblaze:allmodconfig complains for some configurations that 'heartbe=
at'
> is redefined as different kind of symbol. This is seen in test compiles=

> of watchdog drivers, which often use 'heartbeat' as ststic variable.
>=20
> Since 'heartbeat' is an unfortunate name for a global function,
> rename it to microblaze_heartbeat. Also rename the setup function
> to microblaze_setup_heartbeat.
>=20
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Use microblaze_ instead of xilinx_ as function prefix.
>=20
>  arch/microblaze/include/asm/setup.h |    4 ++--
>  arch/microblaze/kernel/heartbeat.c  |    4 ++--
>  arch/microblaze/kernel/timer.c      |    4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)

Applied. both to microblaze next branch.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--mPK4nQLnLq7a8k856VuQ4E3khKjMRAkf9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMDhdkACgkQykllyylKDCFH4gCfdk6WqmqdN7lNj2Qj0Gx7Qv4L
YNMAn0AUxxU4bZ25ItbDZi6hLc6GsijA
=afGn
-----END PGP SIGNATURE-----

--mPK4nQLnLq7a8k856VuQ4E3khKjMRAkf9--
