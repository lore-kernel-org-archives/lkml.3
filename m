Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3IQNFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:05:54 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47609 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3IQNFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:05:53 -0400
Message-ID: <523853A6.3020202@monstr.eu>
Date: Tue, 17 Sep 2013 15:05:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 14/28] microblaze: use early_init_dt_scan
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-15-git-send-email-robherring2@gmail.com>
In-Reply-To: <1379372965-22359-15-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Lpa0GQHp6MXus22vskxWhXXshSwM7PNTB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Lpa0GQHp6MXus22vskxWhXXshSwM7PNTB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/17/2013 01:09 AM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>=20
> Convert microblaze to use new early_init_dt_scan function.
>=20
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: microblaze-uclinux@itee.uq.edu.au
> ---
>  arch/microblaze/kernel/prom.c  | 17 +++--------------
>  arch/microblaze/kernel/setup.c |  2 +-
>  2 files changed, 4 insertions(+), 15 deletions(-)

No problem on Microblaze with this change.
Tested-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--Lpa0GQHp6MXus22vskxWhXXshSwM7PNTB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlI4U6YACgkQykllyylKDCEs7ACgl0K7nqCqYVMAthBh6lMvoMJy
bogAn3EYIg4OHxnJ32lAjm9V03IWdXya
=RYSw
-----END PGP SIGNATURE-----

--Lpa0GQHp6MXus22vskxWhXXshSwM7PNTB--
