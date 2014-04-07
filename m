Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbaDGMYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:24:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51984 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbaDGMYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:24:18 -0400
Message-ID: <534298E7.2020409@monstr.eu>
Date: Mon, 07 Apr 2014 14:24:07 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v2 2/5] ARM: zynq: dt: Convert to preprocessor includes
References: <1396653256-28397-1-git-send-email-soren.brinkmann@xilinx.com> <1396653256-28397-3-git-send-email-soren.brinkmann@xilinx.com> <53423E75.3020008@monstr.eu> <53429754.8080105@topic.nl>
In-Reply-To: <53429754.8080105@topic.nl>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="FjHgvRCGHXXBk3uBA4is7JeNubgpQPmD7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FjHgvRCGHXXBk3uBA4is7JeNubgpQPmD7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On 04/07/2014 02:17 PM, Mike Looijmans wrote:
> On 04/07/2014 07:58 AM, Michal Simek wrote:
>> Hi Soren,
>>
>> On 04/05/2014 01:14 AM, Soren Brinkmann wrote:
>>> Convert all Zynq DT files to the dtc preprocessor include syntax.
>>> This allows to include header files in the devicetrees like other
>>> SoC-types already do.
>>>
>>> Inspired-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
>>> (http://www.spinics.net/lists/arm-kernel/msg319832.html)
>>>
>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>
>> These 4 patches needs more wider discussion if this is helpful or
>> not. Currently I can't see any value in it because everything
>> is just generated and fixed. I think I had the same discussion
>> with Laurent some weeks ago regarding this.
>=20
> I would be kinda neutral here. I'd consider it helpful, it improves rea=
dability (regardless of whether they=20
are generated or hand crafted). That's convenient for things like interru=
pt sensitivity,
I can't remember whether 4 is level or edge type. On the other hand, the =
clock indices are just
 as much magic numbers as the memory addresses. If I suspect an error in =
that area, I'd start by lokking
in /sys/kernel/debug/clk but wouldn't start in the DT.
>=20
>> IRC the origin idea to use this was especially for people who
>> writing these DTS by hand which is not our case - at least
>> for majority of our customers.
>=20
> I write them by hand. Is there any other way?

Device-tree BSP and in 2014.01 there will be new BSP which just generate
them directly from the Vivado tools which just target your reference desi=
gn.
You can connect your custom IP (or Xilinx or 3rd party) directly to the G=
IC
which using different IRQ sensitivity with whatever register addresses
and make no sense to write it by hand.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--FjHgvRCGHXXBk3uBA4is7JeNubgpQPmD7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNCmOcACgkQykllyylKDCFmFQCaApJaw6/8TZPhAwpZ8Pw0aI5j
7QEAn0KeJu/1axANFxaBbBwAr0kNahND
=svZR
-----END PGP SIGNATURE-----

--FjHgvRCGHXXBk3uBA4is7JeNubgpQPmD7--
