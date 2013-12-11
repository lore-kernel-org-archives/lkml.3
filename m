Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3LKORw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:17:52 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:39544 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3LKORt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:17:49 -0500
Message-ID: <52A87401.5030001@monstr.eu>
Date: Wed, 11 Dec 2013 15:17:37 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 4/5] dt/bindings: remove device_type "network" references
References: <1386760555-22732-1-git-send-email-grant.likely@linaro.org> <1386760555-22732-5-git-send-email-grant.likely@linaro.org>
In-Reply-To: <1386760555-22732-5-git-send-email-grant.likely@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="vBl60LhE47qPLUR5oJjopaVBpEPhUQkau"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vBl60LhE47qPLUR5oJjopaVBpEPhUQkau
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/11/2013 12:15 PM, Grant Likely wrote:
> device_type is deprecated and the kernel doesn't require it in most
> cases. The only exceptions for flat tree users are the "gianfar",
> "ucc_geth" and "ibm,emac" bindings, and arguably that requirement could=

> be relaxed for ucc_geth and ibm,emac (that is a task for separate
> patches though).
>=20
> This patch removes references to device_type=3D"network" from the bindi=
ng
> documentation where possible and removes the properties from ARM and
> microblaze dts files. This patch does not modify the powerpc .dts files=

> since there are a much larger number of them affected and I think the
> ucc_geth, ibm,emac and gianfar users should be addressed before clearin=
g
> out the references to reduce the chance of breakage.
>=20
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Michal Simek <monstr@monstr.eu>
> ---
>  Documentation/devicetree/bindings/marvell.txt                    | 2 -=
-
>  Documentation/devicetree/bindings/net/marvell-orion-net.txt      | 2 -=
-
>  Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt | 1 -=

>  arch/arm/boot/dts/dove.dtsi                                      | 1 -=

>  arch/arm/boot/dts/kirkwood.dtsi                                  | 2 -=
-
>  arch/arm/boot/dts/orion5x.dtsi                                   | 1 -=

>  arch/microblaze/platform/generic/system.dts                      | 1 -=

>  7 files changed, 10 deletions(-)

Acked-by: Michal Simek <monstr@monstr.eu>

btw: what device types can be used?
I am having them for serial, watchdog, pci, memory, cpu, ethernet-phy
(will remove network from our generator).

when I grep kernel there are others types like soc, ipmi and a lot for po=
werpc.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--vBl60LhE47qPLUR5oJjopaVBpEPhUQkau
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKodAEACgkQykllyylKDCE3oQCfYWDcIe6YGTjoGRRX5ZJq78Y0
zpwAnjr3Xmip47sdCv2q3ZOSjW6w/eIT
=8Abu
-----END PGP SIGNATURE-----

--vBl60LhE47qPLUR5oJjopaVBpEPhUQkau--
