Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740AbaGYHik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:38:40 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52738 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759641AbaGYHig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:38:36 -0400
Message-ID: <53D20977.2050605@monstr.eu>
Date: Fri, 25 Jul 2014 09:38:31 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 04/11] ARM: dts: zynq: Update deprecated xuartps clock
 names
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <1406242820-20140-5-git-send-email-afaerber@suse.de> <82ab6426-211e-451e-99c3-df40dbea817e@BN1AFFO11FD039.protection.gbl> <53D1931C.7080409@suse.de> <50aad941-92d9-428a-a708-77040e24b651@BY2FFO11FD008.protection.gbl>
In-Reply-To: <50aad941-92d9-428a-a708-77040e24b651@BY2FFO11FD008.protection.gbl>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="R2bCpt5LAqnCgcvOlv8FB43VRvEwqhIVe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R2bCpt5LAqnCgcvOlv8FB43VRvEwqhIVe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/25/2014 01:24 AM, S=C3=B6ren Brinkmann wrote:
> On Fri, 2014-07-25 at 01:13AM +0200, Andreas F=C3=A4rber wrote:
>> Am 25.07.2014 01:09, schrieb S=C3=B6ren Brinkmann:
>>> On Fri, 2014-07-25 at 01:00AM +0200, Andreas F=C3=A4rber wrote:
>>>> Avoids deprecation warning messages.
>>>
>>> A patch that updates those names is already in armsoc.
>>
>> Which tree/branch should I base this series on then? It seemed the
>> Xilinx branches were all heavily outdated some days ago, so this is
>> against vanilla v3.16-rc6.

I have updated that branches. From my experience none is looking
at these branches and I mainly use them for communication
with arm-soc where sign tags are used which you can see them there.

>=20
> That is something for the maintainers to answer. But in general, you're=

> adding a lot of stuff that is not yet upstream, AFAIK. Some is still
> under review I think (like QSPI), others are just staged for the next
> merge window and parts are still in flight. Michal hopefully has a
> better overview.
> This particular patch can simply be omitted I think.

There are several options and I think the best is arm-soc tree
where you can see what have been accepted.
And also I believe all arm-soc trees are added to linux-next.

That's why I would use linux-next or arm-soc.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--R2bCpt5LAqnCgcvOlv8FB43VRvEwqhIVe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPSCXgACgkQykllyylKDCHDkQCeKJx4viqtHZFus/SZhQ23sUYt
R1gAnR7Zmsg5fpnjYqTcVc95k6jRZf9D
=5o7C
-----END PGP SIGNATURE-----

--R2bCpt5LAqnCgcvOlv8FB43VRvEwqhIVe--
