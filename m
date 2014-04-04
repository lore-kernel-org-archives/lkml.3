Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaDDKCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 06:02:22 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54852 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaDDKCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 06:02:19 -0400
Message-ID: <533E8325.5000503@monstr.eu>
Date: Fri, 04 Apr 2014 12:02:13 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: sourav <sourav.poddar@ti.com>
CC: Harini Katakam <harinik@xilinx.com>, broonie@kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] SPI: Add driver for Cadence SPI controller
References: <1396523431-14519-1-git-send-email-harinik@xilinx.com> <533E7588.5060209@ti.com> <533E7A3C.3060302@ti.com>
In-Reply-To: <533E7A3C.3060302@ti.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="NcuilO6TNIcHFGELEbSvXi4h8juiJ7aB6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NcuilO6TNIcHFGELEbSvXi4h8juiJ7aB6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Sourav

On 04/04/2014 11:24 AM, sourav wrote:
> HI,
> On Friday 04 April 2014 02:34 PM, sourav wrote:
>> Hi Harini,
>> On Thursday 03 April 2014 04:40 PM, Harini Katakam wrote:
>>> Add driver for Cadence SPI controller. This is used in Xilinx Zynq.
>>>
>>> Signed-off-by: Harini Katakam<harinik@xilinx.com>
>>> ---
>> I had looked at cadence qspi controller. What I can see is that your
>> patch implements "normal spi ode of operation" ? and the patch looks f=
ine.
>> But, to avail the maximum throughput, I see cadence qspi supports
>> direct/indirect mode of operations, as well as read data capture logic=
=2E
>>
>> So, do you intent to add any of the above in your driver?
>>
> Looks like, I got a bit confused. This is not cadence QSPI controller b=
ut only SPI controller.
> Sorry for the noise.

Look at this one
http://www.spinics.net/lists/kernel/msg1716894.html

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--NcuilO6TNIcHFGELEbSvXi4h8juiJ7aB6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM+gyUACgkQykllyylKDCGA2wCgl0wVsHuw5wpfuG+te6wJTjZS
ABcAoIISwm0Wp9p6bFvL0PvUoZ8pkcUM
=sAYZ
-----END PGP SIGNATURE-----

--NcuilO6TNIcHFGELEbSvXi4h8juiJ7aB6--
