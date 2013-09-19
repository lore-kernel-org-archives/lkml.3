Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3ISOKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:10:52 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:49776 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3ISOKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:10:50 -0400
Message-ID: <523B05E6.90605@monstr.eu>
Date: Thu, 19 Sep 2013 16:10:46 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pavel Machek <pavel@denx.de>, Michal Simek <monstr@monstr.eu>,
        Alan Tull <atull@altera.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: /sys rules Re: [RFC PATCH] fpga: Introduce new fpga subsystem
References: <cover.1379519753.git.michal.simek@xilinx.com> <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com> <1379539063.31417.23.camel@atx-linux-37> <523AD814.1060406@monstr.eu> <20130919111719.GA26246@amd.pavel.ucw.cz> <523ADE58.2070103@monstr.eu> <20130919125237.GA7125@amd.pavel.ucw.cz> <20130919140633.GC19943@kroah.com>
In-Reply-To: <20130919140633.GC19943@kroah.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RiD3G2NTpssr7O9XuPiJdoqW6InfIkXUH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RiD3G2NTpssr7O9XuPiJdoqW6InfIkXUH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/19/2013 04:06 PM, Greg KH wrote:
> On Thu, Sep 19, 2013 at 02:52:37PM +0200, Pavel Machek wrote:
>> On Thu 2013-09-19 13:22:00, Michal Simek wrote:
>>> On 09/19/2013 01:17 PM, Pavel Machek wrote:
>>
>>>>> Status is just there and for my zynq devcfg driver I do export some=
 status
>>>>> bits.
>>>>>
>>>>> root@petalinux:~# cat /sys/class/fpga/fpga0/status
>>>>> partial_bitstream_status: 0
>>>>> prog_done_status: 1
>>>>> dbg_lock_status: 0
>>>>> seu_lock_status: 0
>>>>> aes_en_lock_status: 0
>>>>> aes_status: 0
>>>>> seu_status: 0
>>>>> spniden_status: 1
>>>>> spiden_status: 1
>>>>> niden_status: 1
>>>>> dbgen_status: 1
>>>>> dap_en_status: 7
>>>>
>>>> This is single file? If so, it needs to be changed. Greg is rather
>>>> clear about that.
>>>
>>> Don't you have a link to these rules? I have seen any paragraph from =
Greg
>>> about it but I forget where was it.
>>
>> "one value per file" and "there must be documentation in
>> Documentation/ for each file" are the rules, iirc.
>>
>> There's Documentation/sysfs-rules.txt, but it does not seem too
>> relevant.
>=20
> Documentation/filesystems/sysfs.txt says it.  It probably should be
> added to sysfs-rules.txt as well, but the odds that anyone ever reads
> the documentation is so low I doubt it's even worth it.
>=20
> Also, all sysfs files have to be documented in Documentation/ABI/ which=

> this patch does not do :(
>=20
> And yes, multiple values in a single sysfs file is not allowed at all.
>=20

ok. I will read that. This is output from my fpga end driver - nothing
what I have sent for review.
Can you please look at origin patch and tell me what you think about it?

Thanks,
Michal




--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--RiD3G2NTpssr7O9XuPiJdoqW6InfIkXUH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlI7BeYACgkQykllyylKDCE+5ACfd/e0p5CFzHk7iQ8+8M+vc3PZ
Tk8AnjLLvsXNvemfAef4rIquh2/8KeL6
=bk1V
-----END PGP SIGNATURE-----

--RiD3G2NTpssr7O9XuPiJdoqW6InfIkXUH--
