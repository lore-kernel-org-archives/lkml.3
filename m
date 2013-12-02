Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab3LBTnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:43:06 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:50973 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab3LBTnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:43:00 -0500
Message-ID: <529CE2C0.5070401@monstr.eu>
Date: Mon, 02 Dec 2013 20:42:56 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH v3 1/2] mmc: arasan: Add driver for Arasan SDHCI
References: <1386007357-11956-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1386007357-11956-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3nr2BQRAj1aUNcgnhQemdqKOLhiO9SMsc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3nr2BQRAj1aUNcgnhQemdqKOLhiO9SMsc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/02/2013 07:02 PM, Soren Brinkmann wrote:
> Add a driver for Arasan's SDHCI controller core.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Acked-by: Rob Herring <rob.herring@calxeda.com> [binding]
> ---
> As discussed, I left binding and license header as is and fixed the typ=
os.
>=20
> v3:
>  - fix typo in binding documentation
>  - add missing '>' in MODULE_AUTHOR string
> v2:
>  - document 'interrupts' and 'interrupt-parent' properties in the drive=
r
>    bindings
>  - append '-8.9a' IP version specifier to comaptibility string
>=20
>    	Thanks,
> 	S=C3=B6ren
>=20
>  .../devicetree/bindings/mmc/arasan,sdhci.txt       |  27 +++
>  MAINTAINERS                                        |   1 +
>  drivers/mmc/host/Kconfig                           |  12 ++
>  drivers/mmc/host/Makefile                          |   1 +
>  drivers/mmc/host/sdhci-of-arasan.c                 | 224 +++++++++++++=
++++++++
>  5 files changed, 265 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mmc/arasan,sdhci.=
txt
>  create mode 100644 drivers/mmc/host/sdhci-of-arasan.c

Acked-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--3nr2BQRAj1aUNcgnhQemdqKOLhiO9SMsc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKc4sAACgkQykllyylKDCGZZwCeO0pTc5NWVETFcJOPE+pdARFH
iCkAn39R+KL/403QXOpoKti5oo/HNqQS
=QuoN
-----END PGP SIGNATURE-----

--3nr2BQRAj1aUNcgnhQemdqKOLhiO9SMsc--
