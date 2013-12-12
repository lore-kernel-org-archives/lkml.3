Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab3LLItJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:49:09 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:62415 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3LLItG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:49:06 -0500
Message-ID: <52A97878.7050503@monstr.eu>
Date: Thu, 12 Dec 2013 09:48:56 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH] ARM: zynq: add gem support
References: <1386782989-2720-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1386782989-2720-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="hbahMkv0FhjLHKtsfaD5tmGvVEijacQL8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hbahMkv0FhjLHKtsfaD5tmGvVEijacQL8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/11/2013 06:29 PM, Soren Brinkmann wrote:
> From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
>=20
> The zynq includes a Cadence GEM IP core. This is compatible with the ma=
cb driver.
> Add it to the zynq-7000 DT.
>=20
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Cc: Michal Simek <michal.simek@xilinx.com>
> Cc: Josh Cartwright <josh.cartwright@ni.com>
> [soren: rebased to current Linus tree, added zc706 + zed support, moved=
 phy-mode property to board level dtses]
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> This has a soft dependency on the net-next tree which has some patches =
for the
> macb driver which are required for full functionality. But adding this =
patch to
> any tree without net-next shouldn't do any harm, network might be
> non-operational at the worst - I think.
>=20
> 	S=C3=B6ren
>=20
>  arch/arm/boot/dts/zynq-7000.dtsi | 18 ++++++++++++++++++
>  arch/arm/boot/dts/zynq-zc702.dts |  5 +++++
>  arch/arm/boot/dts/zynq-zc706.dts |  5 +++++
>  arch/arm/boot/dts/zynq-zed.dts   |  5 +++++
>  4 files changed, 33 insertions(+)

Applied to zynq/dt branch.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--hbahMkv0FhjLHKtsfaD5tmGvVEijacQL8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKpeHgACgkQykllyylKDCHYsQCfeFjLqxanXRX8VacNCpnBZtrW
bT8AoIvyP4TDX+hqNOjKVq+nrv1MbQmp
=zdAj
-----END PGP SIGNATURE-----

--hbahMkv0FhjLHKtsfaD5tmGvVEijacQL8--
