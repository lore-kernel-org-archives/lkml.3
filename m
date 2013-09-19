Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3ISLWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:22:08 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:63931 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3ISLWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:22:06 -0400
Message-ID: <523ADE58.2070103@monstr.eu>
Date: Thu, 19 Sep 2013 13:22:00 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>
CC: Alan Tull <atull@altera.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
References: <cover.1379519753.git.michal.simek@xilinx.com> <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com> <1379539063.31417.23.camel@atx-linux-37> <523AD814.1060406@monstr.eu> <20130919111719.GA26246@amd.pavel.ucw.cz>
In-Reply-To: <20130919111719.GA26246@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="WfNSFJTCg4K9xKFdLfuDASg0pcou7XGeH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WfNSFJTCg4K9xKFdLfuDASg0pcou7XGeH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/19/2013 01:17 PM, Pavel Machek wrote:
> Hi!
>=20
>>> This code also creates a set of files under /sys for each separate fp=
ga.
>>> I.e. checking status by looking at /sys/class/fpga/fpag0/status.  It
>>> would be pretty small changes to control reseting the fpga by adding =
a
>>> 'reset' file there also (added first to the framework, and an interfa=
ce
>>> into the low level fpga manager driver).
>>
>> Status is just there and for my zynq devcfg driver I do export some st=
atus
>> bits.
>>
>> root@petalinux:~# cat /sys/class/fpga/fpga0/status
>> partial_bitstream_status: 0
>> prog_done_status: 1
>> dbg_lock_status: 0
>> seu_lock_status: 0
>> aes_en_lock_status: 0
>> aes_status: 0
>> seu_status: 0
>> spniden_status: 1
>> spiden_status: 1
>> niden_status: 1
>> dbgen_status: 1
>> dap_en_status: 7
>=20
> This is single file? If so, it needs to be changed. Greg is rather
> clear about that.

Don't you have a link to these rules? I have seen any paragraph from Greg=

about it but I forget where was it.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--WfNSFJTCg4K9xKFdLfuDASg0pcou7XGeH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlI63lkACgkQykllyylKDCEyVwCfUa6uJA3qkufqEdxYWCpPc9ZB
7pgAn3CjoU6Hj7qDv3ISoojC3LVH6gCU
=aUhN
-----END PGP SIGNATURE-----

--WfNSFJTCg4K9xKFdLfuDASg0pcou7XGeH--
