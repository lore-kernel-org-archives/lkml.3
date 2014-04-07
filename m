Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaDGFsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:48:04 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33458 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbaDGFsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:48:00 -0400
Message-ID: <53423C0C.6050308@monstr.eu>
Date: Mon, 07 Apr 2014 07:47:56 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>, devicetree@vger.kernel.org,
        Mike Looijmans <mike.looijmans@topic.nl>, Gerhard Sittig <gsi@denx.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/3] ARM: zynq: dt: Add I2C nodes to Zynq device tree
References: <1396646876-27336-1-git-send-email-soren.brinkmann@xilinx.com> <1396646876-27336-3-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1396646876-27336-3-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="p8bsXLsKiuUrJUtiaswMo2LuPJXrHE5aa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--p8bsXLsKiuUrJUtiaswMo2LuPJXrHE5aa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/04/2014 11:27 PM, Soren Brinkmann wrote:
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Tested-by: Michal Simek <michal.simek@xilinx.com>
> ---
>=20
> Changes in v5:
>  - use lower case hex digits in 'reg' property
>=20
> Changes in v4: None
> Changes in v3: None
> Changes in v2:
>  - replace 'pmbus' with 'ti' in compatibility strings of UCD devices
>=20
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 22 ++++++++++++
>  arch/arm/boot/dts/zynq-zc702.dts | 76 ++++++++++++++++++++++++++++++++=
++++++++
>  arch/arm/boot/dts/zynq-zc706.dts | 68 ++++++++++++++++++++++++++++++++=
+++
>  3 files changed, 166 insertions(+)

Applied to zynq-dt branch.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--p8bsXLsKiuUrJUtiaswMo2LuPJXrHE5aa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNCPAwACgkQykllyylKDCFuIACfW6FjWlMzosUcfWOUH3s13ylR
qD4AoJT9Jkx61X4OHweHaL4u5tX4Xkt8
=hafe
-----END PGP SIGNATURE-----

--p8bsXLsKiuUrJUtiaswMo2LuPJXrHE5aa--
