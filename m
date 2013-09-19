Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3ISLCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:02:33 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33492 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3ISLCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:02:32 -0400
Message-ID: <523AD9C5.8060006@monstr.eu>
Date: Thu, 19 Sep 2013 13:02:29 +0200
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
References: <cover.1379519753.git.michal.simek@xilinx.com> <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com> <20130918191517.GQ19937@titan.lakedaemon.net> <20130918203247.GA11181@obsidianresearch.com> <1379539063.31417.23.camel@atx-linux-37> <20130919100833.GC19346@amd.pavel.ucw.cz>
In-Reply-To: <20130919100833.GC19346@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="HkAfrNCcAf7EoDwamd6apM7DoNJKq5SKe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HkAfrNCcAf7EoDwamd6apM7DoNJKq5SKe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/19/2013 12:08 PM, Pavel Machek wrote:
> Hi!
>=20
>> The firmware approach is interesting.  It might be less flexible
>> compared with my original code (see link to git below) that this is
>=20
> On the other hand... that's the interface world wants, right? To most
> users, fpga bitstream is just a firmware.

It is one nice way how to get data from one place to another and
it is easy to handle. Using different methods is also possible.

>> Is there some way a per-device userspace helper can be added that can
>> handle adding the headers?  Such that different fpga types get differe=
nt
>> helpers?
>=20
> https://www.kernel.org/doc/Documentation/firmware_class/README
>=20
>  4), userspace:
>      - hotplug: cat appropriate_firmware_image > \
>        		    			       /sys/class/firmware/xxx/data
>=20
> I assume udev's firmware.sh could be modified to add headers.
>=20
> But... if same bitstream is expected to work across multiple FPGAs (is
> it?) maybe kernel should hide that difference and provide headers
> itself.

There could be a configuration where you want to load one bitstream
to more fpgas with the same type. I can imagine this system and use cases=
=2E

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--HkAfrNCcAf7EoDwamd6apM7DoNJKq5SKe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlI62cUACgkQykllyylKDCEHjwCeJdx0ufzNnWCRjiaI8aXXFX67
IpIAnj6RghqkBsLOLbpjTa5OPSdy9M7k
=YJkO
-----END PGP SIGNATURE-----

--HkAfrNCcAf7EoDwamd6apM7DoNJKq5SKe--
