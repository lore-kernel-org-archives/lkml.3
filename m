Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaAFLSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:18:40 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40080 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbaAFLSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:18:37 -0500
Message-ID: <52CA9103.6060803@monstr.eu>
Date: Mon, 06 Jan 2014 12:18:27 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH v3 2/2] arm: dt: zynq: Add SDHCI nodes
References: <1386007357-11956-1-git-send-email-soren.brinkmann@xilinx.com> <1386007357-11956-2-git-send-email-soren.brinkmann@xilinx.com> <529CE36C.4020707@monstr.eu>
In-Reply-To: <529CE36C.4020707@monstr.eu>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="0w2N76OdxlLSISqPG4hw1IM9m0L9FhK0T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0w2N76OdxlLSISqPG4hw1IM9m0L9FhK0T
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/02/2013 08:45 PM, Michal Simek wrote:
> On 12/02/2013 07:02 PM, Soren Brinkmann wrote:
>> Add nodes for the Arasan SDHCI controller to Zynq dts files.
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> ---
>> v2:
>>  - update compatibilty string according to changes in 1/2 (append
>>    '-8.9a' IP version string)
>> ---
>>  arch/arm/boot/dts/zynq-7000.dtsi | 20 ++++++++++++++++++++
>>  arch/arm/boot/dts/zynq-zc702.dts |  4 ++++
>>  arch/arm/boot/dts/zynq-zc706.dts |  4 ++++
>>  arch/arm/boot/dts/zynq-zed.dts   |  4 ++++
>>  4 files changed, 32 insertions(+)
>=20
> Chris: It is up to you if you want to take this through your tree
> or just let me to take it through my tree. It is adding new nodes
> to DTS file that's why it shouldn't be any problem to apply it
> separately.
>=20
> Anyway please let me know what you think.
> If you want to add it to your tree here is my
>=20
> Acked-by: Michal Simek <monstr@monstr.eu>

I have added this patch to my zynq/dt branch.
We discussed this in other patch and these dt changes should go through
arm-soc tree.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--0w2N76OdxlLSISqPG4hw1IM9m0L9FhK0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLKkQMACgkQykllyylKDCGPEQCgk4jgaBt/TlnGXYrkIPIIHSWV
qIgAoIyErAbINWkBamuZz+uXcXQIn/Lm
=qSUk
-----END PGP SIGNATURE-----

--0w2N76OdxlLSISqPG4hw1IM9m0L9FhK0T--
