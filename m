Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3ISPOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 11:14:35 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:35380 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3ISPOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:14:33 -0400
Message-ID: <523B14D0.3040607@monstr.eu>
Date: Thu, 19 Sep 2013 17:14:24 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Yves Vandervennet <rocket.yvanderv@gmail.com>
CC: monstr@monstr.eu, Alan Tull <atull@altera.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
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
References: <cover.1379519753.git.michal.simek@xilinx.com> <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com> <1379539063.31417.23.camel@atx-linux-37> <523AD814.1060406@monstr.eu> <CADuitaA3PLaOgmqXzfMdMDaXg7G6bT-DufjcuhtWfvaoWRj__Q@mail.gmail.com>
In-Reply-To: <CADuitaA3PLaOgmqXzfMdMDaXg7G6bT-DufjcuhtWfvaoWRj__Q@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="A3MTpWi8tcO8FnGktQK9J5jNvQ0Ql8mtD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A3MTpWi8tcO8FnGktQK9J5jNvQ0Ql8mtD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/19/2013 04:42 PM, Yves Vandervennet wrote:
> HI Michal.,
>=20
>=20
> On Thu, Sep 19, 2013 at 5:55 AM, Michal Simek <monstr@monstr.eu> wrote:=

>=20
>>
>>
>>>> Will this framework handle more than one fpga at a time?
>>
>>> I didn't tried that because I don't have any suitable hw for this on =
my
>> desk
>>> but I there shouldn't be any problem in that.
>>
> Supporting multiple FPGA's at one time is key.
>=20
>>
>>>> Is there some way a per-device userspace helper can be added that ca=
n
>>>> handle adding the headers?  Such that different fpga types get diffe=
rent
>>>> helpers?
>>
>>> What do you exactly mean by that? Any example what do you want to ach=
ieve?
>>
> Bit streams may not be in raw format, so using 'cat' is not possible.
> Xilinx and Altera have their own bit stream "richer" format, that can n=
eed
> to be processed before they are presented to the driver(s). So, a hotpl=
ug
> helper per manufacturer/FPGA is required. Assuming 'cat' will be used i=
s
> too limited.
> Does it make sense to you?

Sure. We are handling this at the driver level but as I mentioned
previously these specific functions should be added to xilinx/altera.c fi=
le
(like crc checking mechanisms, etc).
Only one question remain which is if this driver should provide any hook
for this functions or these functions should be called in the end driver.=


Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--A3MTpWi8tcO8FnGktQK9J5jNvQ0Ql8mtD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlI7FNAACgkQykllyylKDCF8hgCeNJkJjGY5CvjlOLOb6VI803P4
ohQAn2JoiR3NGpCFdG1KyucrXDeUlPkj
=bNMt
-----END PGP SIGNATURE-----

--A3MTpWi8tcO8FnGktQK9J5jNvQ0Ql8mtD--
