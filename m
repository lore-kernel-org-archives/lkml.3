Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab3IXP65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:58:57 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:61889 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3IXP64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:58:56 -0400
Message-ID: <5241B6BC.1010301@monstr.eu>
Date: Tue, 24 Sep 2013 17:58:52 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alan Tull <atull@altera.com>
CC: Pavel Machek <pavel@denx.de>,
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
References: <cover.1379519753.git.michal.simek@xilinx.com>  <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>  <20130918191517.GQ19937@titan.lakedaemon.net>  <20130918203247.GA11181@obsidianresearch.com>  <1379539063.31417.23.camel@atx-linux-37>  <20130919100833.GC19346@amd.pavel.ucw.cz> <523AD9C5.8060006@monstr.eu>  <1379710523.21515.4.camel@atx-linux-37> <1380038126.13235.12.camel@atx-linux-37>
In-Reply-To: <1380038126.13235.12.camel@atx-linux-37>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="C2h97DOmBxeDgx6AfSBoi1Q0KRwnnMmvu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C2h97DOmBxeDgx6AfSBoi1Q0KRwnnMmvu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 09/24/2013 05:55 PM, Alan Tull wrote:
>=20
>> I have ported the altera fpga manager driver to work with your version=

>> of the fpga manager framework.  It works fine if I use the
>> firmware_class.c's built-in support to load the firmware, but not with=
 a
>> userspace helper.
>>
>=20
>=20
> Hi Michal,
>=20
> I cleaned up my udev rules and now I see the userspace helper working.
> Just adding one udev rule that points to the standard hotplug-script wa=
s
> sufficient to see the userspace script working nicely. =20
>=20
> All in all, the firmware interface seems pretty easy to use and it give=
s
> us the flexibility to either use the kernel to load the firmware or to
> use scripts, so it should work with a variety of use cases.
>=20
> Since we are arriving at a solution that is suitable for the both of us=
,
> I expect you will be able to add Dinh and myself as maintainers here,
> right?  I have no problem with there only being one repo to store
> patches for this subsystem.

Does it mean that you are able to see "loading" file there?

Can you share your script?

Thanks,
Michal



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--C2h97DOmBxeDgx6AfSBoi1Q0KRwnnMmvu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJBtrwACgkQykllyylKDCFDOgCeKjTHB4c0UKIWGYC9R6Qqf1tM
6CQAn07WLoktIDnQA6dR/DRvLUZFUKP3
=Lwj7
-----END PGP SIGNATURE-----

--C2h97DOmBxeDgx6AfSBoi1Q0KRwnnMmvu--
