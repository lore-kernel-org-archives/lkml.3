Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3IWNC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:02:27 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:47874 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3IWNCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:02:25 -0400
Message-ID: <52403BD0.5080807@monstr.eu>
Date: Mon, 23 Sep 2013 15:02:08 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Yves Vandervennet <rocket.yvanderv@gmail.com>
CC: Alan Tull <atull@altera.com>,
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
References: <cover.1379519753.git.michal.simek@xilinx.com> <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com> <1379539063.31417.23.camel@atx-linux-37> <523AD814.1060406@monstr.eu> <CADuitaCjNv2HFCg_y2qpkvXmUmO-jKUVQ2Ra8ACOne1hwAmKJA@mail.gmail.com>
In-Reply-To: <CADuitaCjNv2HFCg_y2qpkvXmUmO-jKUVQ2Ra8ACOne1hwAmKJA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="SCNVSsrFlioklJMvqAFjJB6fVQi9HNulS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SCNVSsrFlioklJMvqAFjJB6fVQi9HNulS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/19/2013 05:18 PM, Yves Vandervennet wrote:
> On Thu, Sep 19, 2013 at 5:55 AM, Michal Simek <monstr@monstr.eu> wrote:=

>=20
>>> Is there some way a per-device userspace helper can be added that can=

>>> handle adding the headers?  Such that different fpga types get differ=
ent
>>> helpers?
>>
>> What do you exactly mean by that? Any example what do you want to achi=
eve?
> Bit streams may not be in raw format, so using 'cat' is not possible.
> Xilinx and Altera have their own bit stream "richer" format, that need
> to be processed before they are presented to the driver(s). So, a
> hotplug helper per manufacturer/FPGA is required. Assuming 'cat' will
> be used is too limiting.
> Does it make sense to you?

Definitely this make sense to me but the point is if this should be
the part of this patch or just separate altera.c/xilinx.c file which
is able to detect and check this format.
I am not saying that it can't be there but currently without
any code I can't see any reason why there should be hook for code
which doesn't exist.

M



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--SCNVSsrFlioklJMvqAFjJB6fVQi9HNulS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJAO9AACgkQykllyylKDCE6FwCfQrmsjmt1ku56/DRoXBlI/ZI8
fy8An3rVnPkawZQnn+B4nMJfs/aLWYqI
=wkZK
-----END PGP SIGNATURE-----

--SCNVSsrFlioklJMvqAFjJB6fVQi9HNulS--
