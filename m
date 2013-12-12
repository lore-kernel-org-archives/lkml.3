Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab3LLTHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:07:17 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:41088 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LLTHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:07:14 -0500
Message-ID: <52AA095D.4020707@monstr.eu>
Date: Thu, 12 Dec 2013 20:07:09 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
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
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com> <1385514296-26702-2-git-send-email-soren.brinkmann@xilinx.com> <52A97979.1030205@monstr.eu> <552285d2-8d57-4509-a014-d97065232376@DB8EHSMHS004.ehs.local>
In-Reply-To: <552285d2-8d57-4509-a014-d97065232376@DB8EHSMHS004.ehs.local>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="so7JksuqHhjCfBKkHf34sCI51cxPQFvDD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--so7JksuqHhjCfBKkHf34sCI51cxPQFvDD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/12/2013 06:01 PM, S=C3=B6ren Brinkmann wrote:
> Hi Michal,
>=20
> On Thu, Dec 12, 2013 at 09:53:13AM +0100, Michal Simek wrote:
>> On 11/27/2013 02:04 AM, Soren Brinkmann wrote:
>>> The bindings for the TTC changed in commit 'arm: zynq: Use standard
>>> timer binding' (e932900a3279b5dbb6d8f43c7b369003620e137c). That chang=
e
>>> removed possible subnodes from this driver rendering the 'clock-range=
s'
>>> property invalid for this node.
>>>
>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>> Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
>>> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>> ---
>>>  arch/arm/boot/dts/zynq-7000.dtsi | 2 --
>>>  1 file changed, 2 deletions(-)
>>
>> I think this is completely unrelated to cpufreq and should just go
>> directly via arm-soc tree.
>> If yes, I will add 1/9 and 2/9 to zynq/dt branch.
>=20
> I agree. This is just clean up that I found during this work. The secon=
d
> patch could go in as well I think. cpufreq will need the CPU nodes
> later, but I think there is no real reason to not add them now.

ok then. 1/9 and 2/9 applied to zynq/dt branch.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--so7JksuqHhjCfBKkHf34sCI51cxPQFvDD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKqCV0ACgkQykllyylKDCFghwCfXr0ypRzJemhq17qm27Qmk9Ig
Ai0An3hX4bFsRTYpuF4AreZcxVj1E2Sg
=NVbt
-----END PGP SIGNATURE-----

--so7JksuqHhjCfBKkHf34sCI51cxPQFvDD--
