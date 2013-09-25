Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3IYOvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:51:51 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:43639 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3IYOvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:51:50 -0400
Message-ID: <5242F880.4020902@monstr.eu>
Date: Wed, 25 Sep 2013 16:51:44 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Yves Vandervennet <rocket.yvanderv@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@denx.de>,
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
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
References: <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com> <1379539063.31417.23.camel@atx-linux-37> <20130919100833.GC19346@amd.pavel.ucw.cz> <523AD9C5.8060006@monstr.eu> <1379710523.21515.4.camel@atx-linux-37> <1380038126.13235.12.camel@atx-linux-37> <5241B6BC.1010301@monstr.eu> <1380039774.14129.6.camel@atx-linux-37> <20130924221802.GC3837@kroah.com> <CADuitaBT2xqPoSRUTU13GXsayJNHfPcM7ZoSLEy5Ai+W+htmRg@mail.gmail.com>
In-Reply-To: <CADuitaBT2xqPoSRUTU13GXsayJNHfPcM7ZoSLEy5Ai+W+htmRg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="q6v5BlUSjbs4FXt0aJbgisqw5Hqv18b7K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q6v5BlUSjbs4FXt0aJbgisqw5Hqv18b7K
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/25/2013 03:55 PM, Yves Vandervennet wrote:
> Greg,
>=20
>>> The default hotplug-script doesn't do anything special (that the kern=
el
>>> couldn't do by itself).  What's great is that it could call another
>>> script that adds headers or does whatever other special un-gzipping o=
r
>>> other massaging that the firmware image needs before it gets loaded.
>>
>> Only if you need to do something "special" like this could it justify
>> not using the in-kernel firmware loader.  Also note that I think futur=
e
>> versions of udev will have the udev firmware loader removed entirely, =
so
>> watch out for that.
> If the bit stream is in raw format, the kernel can deal with it.
> however, there are "richer" formats for the FPGA bit streams that need
> to be parsed in order to extract the raw data that an FPGA accepts. In
> this case, user space must be involved.

For xilinx there are two fpga formats which are commonly used. BIT and BI=
N.
BIT format is that richer one but there is no public documentation availa=
ble
for it. IRC hwicap just support BIT format and because of any unknown dec=
ision
zynq can work just with BIN.
But getting BIN from BIT is easy and currently we have the support
in our driver for doing it.

Not sure what options there are for cplds.

But anyway AFAIK richer formats are not problem for us.

The same situation should be for partial bitstreams too.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--q6v5BlUSjbs4FXt0aJbgisqw5Hqv18b7K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJC+IEACgkQykllyylKDCGKfwCeLu2QEttK0Yow20hJ4F9UrG7H
9TEAnA5Dy5TjlhHtAyjhI52JVrpL6A3w
=hdQA
-----END PGP SIGNATURE-----

--q6v5BlUSjbs4FXt0aJbgisqw5Hqv18b7K--
