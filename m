Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3JGPDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:03:55 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:42163 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3JGPDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:03:53 -0400
Message-ID: <5252CD30.3070305@monstr.eu>
Date: Mon, 07 Oct 2013 17:03:12 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
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
References: <524EC965.70701@monstr.eu> <20131004141646.GA9396@kroah.com> <d700a91e-1319-4c35-895d-55e323c40703@email.android.com> <524ED081.1040600@monstr.eu> <524EF0CE.4040002@zytor.com> <524EFE76.70200@monstr.eu> <524F04FD.5020804@zytor.com> <20131004233341.GA4028@kroah.com> <20131004234929.GB3652@obsidianresearch.com> <875b2a01-be5a-47d1-b89a-9385d54b9b64@email.android.com> <20131005051056.GA7698@obsidianresearch.com> <1c9db96e-7a36-4ec9-ab16-885780ce6de5@email.android.com> <524FB756.3040203@monstr.eu> <c59c68b8-2565-45c5-bfe9-574b76f3f9bc@email.android.com> <5252B2F4.7050600@monstr.eu> <ea858a91-1149-44cc-b2e1-bab1f579915e@email.android.com>
In-Reply-To: <ea858a91-1149-44cc-b2e1-bab1f579915e@email.android.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="FNTI8KCgbkeA08d91CmIPGal6MR5M8smH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FNTI8KCgbkeA08d91CmIPGal6MR5M8smH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/07/2013 04:55 PM, H. Peter Anvin wrote:
> If I recall correctly we simply poked at the FPGA directly from userspa=
ce.=20
Not ideal by any means and also meant we had to have a backup recovery me=
chanism as it meant
 that the FPGA had to be programmed already as the bus interface was in s=
oft IP.

ok. How was that physical hardware connection to device you wanted to tal=
k?
Was it any special IP with MMIO? Or gpio jtag emulation or similar?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--FNTI8KCgbkeA08d91CmIPGal6MR5M8smH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJSzTAACgkQykllyylKDCHqPACeNdJVcL/EeolPvuETIPGb8N2L
ooIAnRADAvsNSeVhnJz3CH3x/VK4OvNA
=dCWu
-----END PGP SIGNATURE-----

--FNTI8KCgbkeA08d91CmIPGal6MR5M8smH--
