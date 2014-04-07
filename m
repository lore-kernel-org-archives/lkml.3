Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaDGF6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:58:21 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45433 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaDGF6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:58:17 -0400
Message-ID: <53423E75.3020008@monstr.eu>
Date: Mon, 07 Apr 2014 07:58:13 +0200
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
        Mike Looijmans <mike.looijmans@topic.nl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v2 2/5] ARM: zynq: dt: Convert to preprocessor includes
References: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com> <1396653256-28397-3-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1396653256-28397-3-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Em4kOlMHxFWq8CivwK7RXajGwODQUH4Qj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Em4kOlMHxFWq8CivwK7RXajGwODQUH4Qj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Soren,

On 04/05/2014 01:14 AM, Soren Brinkmann wrote:
> Convert all Zynq DT files to the dtc preprocessor include syntax.
> This allows to include header files in the devicetrees like other
> SoC-types already do.
>=20
> Inspired-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> (http://www.spinics.net/lists/arm-kernel/msg319832.html)
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

These 4 patches needs more wider discussion if this is helpful or
not. Currently I can't see any value in it because everything
is just generated and fixed. I think I had the same discussion
with Laurent some weeks ago regarding this.
IRC the origin idea to use this was especially for people who
writing these DTS by hand which is not our case - at least
for majority of our customers.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--Em4kOlMHxFWq8CivwK7RXajGwODQUH4Qj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNCPnUACgkQykllyylKDCGCSACeK3V3uvNpObjzC52MLzfNfvAd
Gr4An213/PmlDoHPJpV1XkmQN5/R40wI
=0uHS
-----END PGP SIGNATURE-----

--Em4kOlMHxFWq8CivwK7RXajGwODQUH4Qj--
