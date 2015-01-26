Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbbAZIXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 03:23:05 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44449 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbbAZIXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 03:23:04 -0500
Message-ID: <54C5F965.90100@monstr.eu>
Date: Mon, 26 Jan 2015 09:23:01 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: devicetree@vger.kernel.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ola Jeppson <ola@adapteva.com>
Subject: Re: [PATCH v3] ARM: zynq: DT: Add USB to device tree
References: <1417536431-27759-1-git-send-email-soren.brinkmann@xilinx.com> <d78fedd84f354d80985187f851cb3cd1@BN1AFFO11FD055.protection.gbl> <54C5F89A.3090901@suse.de>
In-Reply-To: <54C5F89A.3090901@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="26uUJ00G4C3tH5aBHLF1Kdpacd3uWfWGs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--26uUJ00G4C3tH5aBHLF1Kdpacd3uWfWGs
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/26/2015 09:19 AM, Andreas F=E4rber wrote:
> Hi Michal,
>=20
> Am 03.12.2014 um 09:39 schrieb Michal Simek:
>> On 12/02/2014 05:07 PM, Soren Brinkmann wrote:
>>> Add USB nodes to zc702, zc706 and zed device trees.
>>>
>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>> ---
>>> v3:
>>>  - rename phy nodes: usb_phy -> phy0
>>>  - rebased onto zynq/dt
>>> v2:
>>>  - remove '@0' from phy node name
>>>  - don't add bogus space
>>> ---
>>>  arch/arm/boot/dts/zynq-7000.dtsi | 20 ++++++++++++++++++++
>>>  arch/arm/boot/dts/zynq-zc702.dts | 11 +++++++++++
>>>  arch/arm/boot/dts/zynq-zc706.dts | 10 ++++++++++
>>>  arch/arm/boot/dts/zynq-zed.dts   | 10 ++++++++++
>>>  4 files changed, 51 insertions(+)
> [...]
>>
>> Applied to zynq/dt.
>=20
> Hm, I don't see this patch in linux-next next-20150123...
>=20
> And if I apply it to my -next based tree, adding corresponding nodes to=

> zynq-parallella.dts, I get repeatedly:
>=20
> [  +0,012242] ci_hdrc ci_hdrc.0: no of_node; not parsing pinctrl DT
> [  +0,000157] ci_hdrc ci_hdrc.0: ChipIdea HDRC found, lpm: 0; cap:
> f090e100 op: f090e140
> [  +0,000081] platform ci_hdrc.0: Driver ci_hdrc requests probe deferra=
l
> [  +0,005360] ci_hdrc ci_hdrc.1: no of_node; not parsing pinctrl DT
> [  +0,000120] ci_hdrc ci_hdrc.1: ChipIdea HDRC found, lpm: 0; cap:
> f0910100 op: f0910140
> [  +0,001810] platform ci_hdrc.1: Driver ci_hdrc requests probe deferra=
l
>=20
> Am I missing any other patches or config options?
> (I do notice that the pinctrl v3 patch that got merged has a trivial bu=
g
> for usb0, for which I'll send a patch later on.)

Why is it deferred? Is it because of pinmuxing stuff?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--26uUJ00G4C3tH5aBHLF1Kdpacd3uWfWGs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlTF+WUACgkQykllyylKDCGemACgngj1COnbYrjLtuBXcbsE3iA/
q7AAniWhCUv1FYVB7w1bLChnzEtJI1Z2
=tvZO
-----END PGP SIGNATURE-----

--26uUJ00G4C3tH5aBHLF1Kdpacd3uWfWGs--
