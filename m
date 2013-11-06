Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3KFHtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:49:24 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39787 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3KFHtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:49:22 -0500
Message-ID: <5279F47E.30606@monstr.eu>
Date: Wed, 06 Nov 2013 08:49:18 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: remove unused NO_MMU Kconfig parameter
References: <1383553818-3711-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1383553818-3711-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2MFS3h51Lmd5CBNS5f8dQGhdWrfMS8OD2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2MFS3h51Lmd5CBNS5f8dQGhdWrfMS8OD2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/04/2013 09:30 AM, Michael Opdenacker wrote:
> This removes the NO_MMU Kconfig parameter,
> which was no longer used anywhere in the source code
> and Makefiles.
>=20
> This also updates a comment refering to this parameter.
>=20
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.co=
m>
> ---
>  arch/microblaze/Kconfig                       | 5 -----
>  arch/microblaze/kernel/hw_exception_handler.S | 4 ++--
>  2 files changed, 2 insertions(+), 7 deletions(-)

Applied.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--2MFS3h51Lmd5CBNS5f8dQGhdWrfMS8OD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJ59H4ACgkQykllyylKDCEPYwCfUMsU49tAr3MbzJNAlyl0kzjm
C7EAn0Rj5enXf+A6DBlJAgXyvbHhMa9B
=k5Rt
-----END PGP SIGNATURE-----

--2MFS3h51Lmd5CBNS5f8dQGhdWrfMS8OD2--
