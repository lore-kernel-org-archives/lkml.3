Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaDGFqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:46:45 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:52787 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaDGFql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:46:41 -0400
Message-ID: <53423BB6.7010508@monstr.eu>
Date: Mon, 07 Apr 2014 07:46:30 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: Re: [PATCH v2 1/5] ARM: zynq: DT: Add 'clock-latency' property
References: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com> <1396653256-28397-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1396653256-28397-2-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9UtMLjXJhM7Hg9PdiTpC0VWpwCMi0HEOQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9UtMLjXJhM7Hg9PdiTpC0VWpwCMi0HEOQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/05/2014 01:14 AM, Soren Brinkmann wrote:
> Specify the 'clock-latency' property to avoid certain cpufreq governors=

> from refusing to work with the following error:
>   ondemand governor failed, too long transition latency of HW, fallback=
 to performance governor
>=20
> Reported-by: Mike Looijmans <mike.looijmans@topic.nl>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Tested-by: Mike Looijmans <mike.looijmans@topic.nl>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> This is a fix from our vendor tree
>=20
> Changes in v2:
>  - This patch has been added
>=20
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 1 +
>  1 file changed, 1 insertion(+)

Applied to zynq-dt.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--9UtMLjXJhM7Hg9PdiTpC0VWpwCMi0HEOQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNCO7cACgkQykllyylKDCGeAQCeKvbpUSMzF8u1c0peEOwBpe+I
1WYAn0lClK852fpiNvEK5mVHIY4JiZ9A
=Wakn
-----END PGP SIGNATURE-----

--9UtMLjXJhM7Hg9PdiTpC0VWpwCMi0HEOQ--
