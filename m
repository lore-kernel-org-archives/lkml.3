Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab3JEG4N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 02:56:13 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:38535 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3JEG4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 02:56:11 -0400
Message-ID: <524FB808.2020008@monstr.eu>
Date: Sat, 05 Oct 2013 08:56:08 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@denx.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@altera.com>, Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
References: <524C6D64.8080801@zytor.com> <20131003064915.GB17155@amd.pavel.ucw.cz> <524EC965.70701@monstr.eu> <20131004141646.GA9396@kroah.com> <d700a91e-1319-4c35-895d-55e323c40703@email.android.com> <524ED081.1040600@monstr.eu> <524EF0CE.4040002@zytor.com> <524EFE76.70200@monstr.eu> <524F04FD.5020804@zytor.com> <20131004233341.GA4028@kroah.com> <20131004234929.GB3652@obsidianresearch.com>
In-Reply-To: <20131004234929.GB3652@obsidianresearch.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="eQEtmEinW3hWr7pW3gx4tKiNmt4hAqQnM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eQEtmEinW3hWr7pW3gx4tKiNmt4hAqQnM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/05/2013 01:49 AM, Jason Gunthorpe wrote:
> On Fri, Oct 04, 2013 at 04:33:41PM -0700, Greg Kroah-Hartman wrote:
>=20
>>> I agree that the firmware interface makes sense when the use of the
>>> FPGA is an implementation detail in a fixed hardware configuration,
>>> but that is a fairly restricted use case all things considered.
>>
>> Ideally I thought this would be just like "firmware", you dump the fil=
e
>> to the FPGA, it validates it and away you go with a new image running =
in
>> the chip.
>=20
> That is 99% of the use cases. The other stuff people are talking about
> is fringe.

yep.

> I've been doing FPGAs for > 10 years and I've never once used read back=

> via the config bus. In fact all my FPGAs turn that feature off once
> they are loaded.
>=20
> Partial reconfiguration is very specialized, and hard to use from a
> FPGA design standpoint.

And also from software point of view in connection to drivers handling.
It means tools supports partial reconfiguration and even Xilinx produce
TRD design where partial reconfiguration is used but it is long way
to go to get this work nicely.

> I also think it is sensible to focus this interface on simple SRAM
> FPGAs, not FLASH based stuff, or whatever complex device required a
> byte code interpreter (never heard of that before).

Agree.

Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--eQEtmEinW3hWr7pW3gx4tKiNmt4hAqQnM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJPuAgACgkQykllyylKDCHSpgCeNyUycfUG4VBQ5pAwSzvvhZff
45IAniQbF1herB5OE1ozMTLcTPW8O7i8
=LODG
-----END PGP SIGNATURE-----

--eQEtmEinW3hWr7pW3gx4tKiNmt4hAqQnM--
