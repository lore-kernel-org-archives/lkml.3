Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaDCPCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:02:39 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:42469 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaDCPCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:02:35 -0400
Message-ID: <533D7806.8070002@monstr.eu>
Date: Thu, 03 Apr 2014 17:02:30 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
CC: dougthompson@xmission.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        michal.simek@xilinx.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, kpc528@gmail.com,
        kalluripunnaiahchoudary@gmail.com, punnaia@xilinx.com,
        Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH] edac: add support for ARM PL310 L2 cache parity
References: <1393770760-32550-1-git-send-email-punnaia@xilinx.com> <a1a9e47a-069c-4285-9899-d5a58cf532c2@CO9EHSMHS003.ehs.local>
In-Reply-To: <a1a9e47a-069c-4285-9899-d5a58cf532c2@CO9EHSMHS003.ehs.local>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3VIAqalIl7Td69EB54RgdsveHTotW6KOS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3VIAqalIl7Td69EB54RgdsveHTotW6KOS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Borislav,

On 03/02/2014 03:32 PM, Punnaiah Choudary Kalluri wrote:
> Add support for ARM Pl310 L2 cache controller parity error
>=20
> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
> ---
>  .../devicetree/bindings/edac/pl310_edac_l2.txt     |   19 ++
>  drivers/edac/Kconfig                               |    7 +
>  drivers/edac/Makefile                              |    1 +
>  drivers/edac/pl310_edac_l2.c                       |  236 ++++++++++++=
++++++++
>  4 files changed, 263 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/edac/pl310_edac_l=
2.txt
>  create mode 100644 drivers/edac/pl310_edac_l2.c

Any comment about this driver?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--3VIAqalIl7Td69EB54RgdsveHTotW6KOS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM9eAYACgkQykllyylKDCFrWwCgkfN56ZwczSkGT8I8TWxw1xpD
MaUAnR7yeU8hp7Pof8dJ7QuPm9N+m1/o
=QK4T
-----END PGP SIGNATURE-----

--3VIAqalIl7Td69EB54RgdsveHTotW6KOS--
