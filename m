Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaDWFcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:32:47 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:38776 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaDWFcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:32:45 -0400
Message-ID: <53575074.6010602@monstr.eu>
Date: Wed, 23 Apr 2014 07:32:36 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Microblaze image hanging in qemu with 3.15-rc
References: <20140422172356.GA15672@roeck-us.net>
In-Reply-To: <20140422172356.GA15672@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="48GPD2HjwBGvANmXt1UD6EBt8jtmVDLDH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--48GPD2HjwBGvANmXt1UD6EBt8jtmVDLDH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Guenter,


On 04/22/2014 07:23 PM, Guenter Roeck wrote:
> Hi all,
>=20
> when trying to run a microblaze image with 3.15-rc1 or 3.15-rc2 in qemu=
,
> I get the following hangup. This used to work with earlier kernels
> with the same configuration.
>=20
> Is this a known problem, or is something wrong with my configuration=20
> or with my qemu command line ?

Is this BE/LE version? Which qemu do you use?
There is endian autodetection in timer and intc driver
which can caused this problem.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--48GPD2HjwBGvANmXt1UD6EBt8jtmVDLDH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXUHUACgkQykllyylKDCEmxwCdFM4AA13I0H3iiHYYqX+opUOL
MWQAn32UfQv/K5SqFAZ+3yHUAdQwbbPf
=/iSV
-----END PGP SIGNATURE-----

--48GPD2HjwBGvANmXt1UD6EBt8jtmVDLDH--
