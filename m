Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbbAFGtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 01:49:03 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45697 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbbAFGtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 01:49:00 -0500
Message-ID: <54AB8555.3090206@monstr.eu>
Date: Tue, 06 Jan 2015 07:48:53 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: error fetching the microblaze tree
References: <20150106100346.6dbab82c@canb.auug.org.au>
In-Reply-To: <20150106100346.6dbab82c@canb.auug.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="vQRWJTBHR3goE8o0vPxwHi7Udwr6lX0ou"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vQRWJTBHR3goE8o0vPxwHi7Udwr6lX0ou
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

sorry for trouble. Server has been moved to 92.62.235.6.
I have changed DNS record but it takes some time to update
it that's why you can't reach it. :-( It will be fixed soon
I believe.

Thanks,
Michal

On 01/06/2015 12:03 AM, Stephen Rothwell wrote:
> Hi Michal,
>=20
> Attempting to fetch the microblaze tree, today (and yesterday) produced=

> this error:
>=20
> fatal: unable to connect to git.monstr.eu:
> git.monstr.eu[0: 89.31.40.14]: errno=3DConnection timed out
>=20

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--vQRWJTBHR3goE8o0vPxwHi7Udwr6lX0ou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlSrhVgACgkQykllyylKDCHwdwCfRMCWzOPyjCUFZoczdmj1bMJx
sPEAoI/9xjkQ8/cf5jOWa1Z1Gkd2x7Ry
=LrNS
-----END PGP SIGNATURE-----

--vQRWJTBHR3goE8o0vPxwHi7Udwr6lX0ou--
