Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab3LLIxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:53:21 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:34699 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3LLIxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:53:17 -0500
Message-ID: <52A97979.1030205@monstr.eu>
Date: Thu, 12 Dec 2013 09:53:13 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/9] arm: dt: zynq: Remove 'clock-ranges' from TTC
 nodes
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com> <1385514296-26702-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1385514296-26702-2-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="OjAdEDEBDNadJWo2w2aQl0EAdPDBqucPa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OjAdEDEBDNadJWo2w2aQl0EAdPDBqucPa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/27/2013 02:04 AM, Soren Brinkmann wrote:
> The bindings for the TTC changed in commit 'arm: zynq: Use standard
> timer binding' (e932900a3279b5dbb6d8f43c7b369003620e137c). That change
> removed possible subnodes from this driver rendering the 'clock-ranges'=

> property invalid for this node.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 2 --
>  1 file changed, 2 deletions(-)

I think this is completely unrelated to cpufreq and should just go
directly via arm-soc tree.
If yes, I will add 1/9 and 2/9 to zynq/dt branch.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--OjAdEDEBDNadJWo2w2aQl0EAdPDBqucPa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKpeXkACgkQykllyylKDCHxYQCfSFe9fVvZqdzQ/938oJmripDg
gS8AnRZaMbXh1iwJuab7ocmgtZZ+RjDB
=rSGA
-----END PGP SIGNATURE-----

--OjAdEDEBDNadJWo2w2aQl0EAdPDBqucPa--
