Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab3EQMOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 08:14:53 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48221 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3EQMOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 08:14:52 -0400
Message-ID: <51961F37.3030202@monstr.eu>
Date: Fri, 17 May 2013 14:14:47 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <joshc@eso.teric.us>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2 0/5] Zynq: revised CCF code
References: <1368467199-8702-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1368467199-8702-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2EUHXNQOXRVASMKVGIRTE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2EUHXNQOXRVASMKVGIRTE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Mike,

I have sent email to Greg to take this patch from this series
though his serial tree because it is unrelated to this clock stuff.

Can you please give me your ACK for these patches or add them
to your CLK tree?

I just need to move this to be able to start to push other drivers
which are related to this.

Thanks,
Michal


On 05/13/2013 07:46 PM, Soren Brinkmann wrote:
> I rebased this series on v3.10-rc1 eliminating all dependencies and inc=
orporated
> Greg's feedback.
> I'll push this also to my github repository.
> https://github.com/sorenb-xlnx/linux-xlnx/tree/zynq/clkc
>=20
> v2:
>  - dropped the 'sort #includes' patches
>=20
> 	S=C3=B6ren
>=20
>=20
> Soren Brinkmann (5):
>   tty: xuartps: Remove suspend/resume functions
>   clk: zynq: Factor out PLL driver
>   clk: zynq: Add clock controller driver
>   arm: zynq: Migrate platform to clock controller
>   clk: zynq: Remove deprecated clock code
>=20
>  .../devicetree/bindings/clock/zynq-7000.txt        | 127 +++--
>  arch/arm/boot/dts/zynq-7000.dtsi                   |  71 +--
>  arch/arm/boot/dts/zynq-zc702.dts                   |   4 -
>  arch/arm/mach-zynq/slcr.c                          |   2 +-
>  drivers/clk/Makefile                               |   2 +-
>  drivers/clk/clk-zynq.c                             | 378 -------------=
--
>  drivers/clk/zynq/Makefile                          |   3 +
>  drivers/clk/zynq/clkc.c                            | 533 +++++++++++++=
++++++++
>  drivers/clk/zynq/pll.c                             | 235 +++++++++
>  drivers/clocksource/cadence_ttc_timer.c            |  23 +-
>  drivers/tty/serial/xilinx_uartps.c                 | 115 +++--
>  include/linux/clk/zynq.h                           |   8 +-
>  12 files changed, 974 insertions(+), 527 deletions(-)
>  delete mode 100644 drivers/clk/clk-zynq.c
>  create mode 100644 drivers/clk/zynq/Makefile
>  create mode 100644 drivers/clk/zynq/clkc.c
>  create mode 100644 drivers/clk/zynq/pll.c
>=20


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2EUHXNQOXRVASMKVGIRTE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGWHzcACgkQykllyylKDCHn9QCfeLs6xmbvcJTfM6cgVFSpFrCk
OFwAoI+ZduvQCiA6MW5FJ/XZ+Q/4pQX9
=yaEo
-----END PGP SIGNATURE-----

------enig2EUHXNQOXRVASMKVGIRTE--
