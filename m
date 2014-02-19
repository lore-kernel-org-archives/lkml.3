Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaBSNvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:51:46 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33509 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaBSNvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:51:45 -0500
Message-ID: <5304B6E8.1090508@monstr.eu>
Date: Wed, 19 Feb 2014 14:51:36 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Lee Jones <lee.jones@linaro.org>, Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] mfd: syscon: Support early initialization
References: <cover.1392807832.git.michal.simek@xilinx.com> <fa3178534fcf4488fc45a9a24e44b2588acb38c6.1392807832.git.michal.simek@xilinx.com> <20140219114132.GC10504@lee--X1> <53049932.8020901@monstr.eu> <20140219121756.GM2669@sirena.org.uk>
In-Reply-To: <20140219121756.GM2669@sirena.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ISkmVBfWGB5lIkGe97in6M5DnKM0ew83F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ISkmVBfWGB5lIkGe97in6M5DnKM0ew83F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/19/2014 01:17 PM, Mark Brown wrote:
> On Wed, Feb 19, 2014 at 12:44:50PM +0100, Michal Simek wrote:
>> On 02/19/2014 12:41 PM, Lee Jones wrote:
>=20
>>> I believe you were waiting for Arnd and/or Mark to comment.
>=20
>> yes on Arnd because Mark already applied that regmap part.
>> But of course any input how to get this done will be helpful.
>=20
> Like I said I've never seen the user you're adding for the regmap API s=
o
> I've no particular opinion on it.

2/2 is the code where I would like to use this when clk subsystem
start to use better io helper functions then just static inline
clk_readl/clk_writel.

Then my 2/2 driver will be just nicer than current implementation.

Regarding syscon changes. I think the right question is if this driver
should be still in drivers/mfd/ or should be moved to somewhere else
(drivers/base for example).

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--ISkmVBfWGB5lIkGe97in6M5DnKM0ew83F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMEtugACgkQykllyylKDCEZ2ACeM/PptI8tNIZCXfy21FK9FMW/
6ZIAnR2H4UCYfzQherqOsZvZ1rUnCXW0
=8G+I
-----END PGP SIGNATURE-----

--ISkmVBfWGB5lIkGe97in6M5DnKM0ew83F--
