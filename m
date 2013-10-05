Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab3JEGtj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 02:49:39 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:53656 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3JEGti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 02:49:38 -0400
Message-ID: <524FB678.4020405@monstr.eu>
Date: Sat, 05 Oct 2013 08:49:28 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
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
References: <cover.1380727889.git.michal.simek@xilinx.com> <524C6D64.8080801@zytor.com> <20131003064915.GB17155@amd.pavel.ucw.cz> <524EC965.70701@monstr.eu> <20131004141646.GA9396@kroah.com> <d700a91e-1319-4c35-895d-55e323c40703@email.android.com> <524ED081.1040600@monstr.eu> <524EF0CE.4040002@zytor.com> <524EFE76.70200@monstr.eu> <524F04FD.5020804@zytor.com> <20131004233341.GA4028@kroah.com> <524F5442.20402@zytor.com>
In-Reply-To: <524F5442.20402@zytor.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="6EuwhS2b9SI0pjAObQITttQ6clq2xb96J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6EuwhS2b9SI0pjAObQITttQ6clq2xb96J
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/05/2013 01:50 AM, H. Peter Anvin wrote:
> On 10/04/2013 04:33 PM, Greg Kroah-Hartman wrote:
>>
>> Ideally I thought this would be just like "firmware", you dump the fil=
e
>> to the FPGA, it validates it and away you go with a new image running =
in
>> the chip.
>>
>> But, it sounds like this is much more complicated, so much so that
>> configfs might be the correct interface for it, as you can do lots of
>> things there, and it is very flexible (some say too flexible...)
>>
>> A char device, with a zillion different custom ioctls is also a way to=

>> do it, but one that I really want to avoid as that gets messy really
>> quickly.
>>
>=20
> I'm not sure that a zillion custom ioctls are necessary, but I think we=

> really need to get a better understanding of the various usage cases
> (and there are going to be ones where an "FPGA driver" simply makes no
> sense at all.)

Isn't this a reason to add this to staging area a see where this can go?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--6EuwhS2b9SI0pjAObQITttQ6clq2xb96J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJPtngACgkQykllyylKDCEANQCfTL+1S3p2bCvAPLEAJ6Iiacwo
PGkAnA+TNkyug8ZqjBmm3IymwTpxw8RA
=TXBH
-----END PGP SIGNATURE-----

--6EuwhS2b9SI0pjAObQITttQ6clq2xb96J--
