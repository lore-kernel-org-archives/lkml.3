Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaB1WxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:53:10 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:50714 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaB1WxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:53:08 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: tglx@linutronix.de, linus.walleij@linaro.org, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irq: Changed the return type of irq_chip.irq_startup() from unsigned int to int
Date: Fri, 28 Feb 2014 22:52:56 +0000
Message-ID: <7150036.UpHTd1PK1K@radagast>
Organization: Imagination Technologies
User-Agent: KMail/4.11.5 (Linux/3.13.4+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393521679-32331-1-git-send-email-jjhiblot@traphandler.com>
References: <CACh+v5Nkuct0J65OHcnSd6Dfq4EyfafY8RpTvdwKXUA7A8_+Xw@mail.gmail.com> <1393521679-32331-1-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7745603.2msArur1kl"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart7745603.2msArur1kl
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday 27 February 2014 18:21:19 Jean-Jacques Hiblot wrote:
>  arch/arm/mach-omap2/gpmc.c                | 2 +-
>  arch/blackfin/mach-common/ints-priority.c | 2 +-
>  arch/ia64/hp/sim/hpsim_irq.c              | 2 +-
>  arch/ia64/kernel/iosapic.c                | 4 ++--
>  arch/ia64/kernel/irq_lsapic.c             | 2 +-
>  arch/ia64/sn/kernel/irq.c                 | 2 +-
>  arch/m68k/apollo/dn_ints.c                | 2 +-
>  arch/m68k/atari/ataints.c                 | 4 ++--
>  arch/m68k/include/asm/irq.h               | 4 ++--
>  arch/m68k/kernel/ints.c                   | 4 ++--
>  arch/m68k/mac/macints.c                   | 4 ++--
>  arch/m68k/platform/coldfire/intc-2.c      | 2 +-
>  arch/m68k/platform/coldfire/intc-simr.c   | 2 +-
>  arch/m68k/q40/q40ints.c                   | 2 +-
>  arch/metag/kernel/irq.c                   | 2 +-
>  arch/mips/jz4740/gpio.c                   | 2 +-
>  arch/mips/kernel/irq_cpu.c                | 2 +-
>  arch/mips/lantiq/irq.c                    | 2 +-
>  arch/mips/sgi-ip27/ip27-irq-pci.c         | 2 +-
>  arch/powerpc/platforms/powermac/pic.c     | 2 +-
>  arch/powerpc/platforms/wsp/ics.c          | 4 ++--
>  arch/powerpc/sysdev/mpic.c                | 2 +-
>  arch/powerpc/sysdev/xics/ics-opal.c       | 2 +-
>  arch/powerpc/sysdev/xics/ics-rtas.c       | 2 +-
>  arch/sparc/kernel/leon_kernel.c           | 2 +-
>  arch/sparc/kernel/leon_pci_grpci1.c       | 2 +-
>  arch/sparc/kernel/leon_pci_grpci2.c       | 2 +-
>  arch/sparc/kernel/pcic.c                  | 2 +-
>  arch/sparc/kernel/sun4d_irq.c             | 2 +-
>  arch/sparc/kernel/sun4m_irq.c             | 2 +-
>  arch/tile/kernel/pci_gx.c                 | 2 +-
>  arch/x86/kernel/apic/io_apic.c            | 2 +-
>  arch/x86/platform/visws/visws_quirks.c    | 2 +-
>  drivers/gpio/gpio-adnp.c                  | 2 +-
>  drivers/gpio/gpio-bcm-kona.c              | 2 +-
>  drivers/gpio/gpio-em.c                    | 2 +-
>  drivers/gpio/gpio-intel-mid.c             | 2 +-
>  drivers/gpio/gpio-lynxpoint.c             | 2 +-
>  drivers/gpio/gpio-mcp23s08.c              | 2 +-
>  drivers/gpio/gpio-tz1090.c                | 2 +-
>  drivers/irqchip/irq-metag.c               | 4 ++--

I think you've missed out drivers/irqchip/irq-metag-ext.c

Thanks
James

>  drivers/pinctrl/pinctrl-adi2.c            | 2 +-
>  drivers/pinctrl/pinctrl-baytrail.c        | 2 +-
>  drivers/pinctrl/pinctrl-msm.c             | 2 +-
>  drivers/pinctrl/pinctrl-nomadik.c         | 2 +-
>  drivers/pinctrl/sirf/pinctrl-sirf.c       | 2 +-
>  drivers/xen/events/events_base.c          | 4 ++--
>  include/linux/irq.h                       | 2 +-
>  kernel/irq/dummychip.c                    | 2 +-
>  49 files changed, 57 insertions(+), 57 deletions(-)

--nextPart7745603.2msArur1kl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTERNPAAoJEKHZs+irPybfWYAP/1h0BOjcoS8d2r1fc65o6id1
KdZTUYN/iiXfTiIfmpvqvJUhW7d34UVwrzWiOO2fTDNbQAZLG8LkGWRW/MfgMlkq
m6MZrJIXY1Thq01qRks0SjHPcGMLwDuVc4hhbXpLqqh/IJ0PYMxCTZYBfQ0kn7OD
HuncjspbyFHnAP5WP/2Aoq9etxhqIuXq/n1DviiPXJaD8I/bCz/8NekCBErbYZQs
Uvy2/LwWFxy6pVT0DtacHu7LOzdT7mfXhVGEXegy3PPs7j6HvUP65O65xYtDFM1G
OEeLHJh7erOrqM+FuWghtDHc0QjlNORkzOi+Zv1+HAT4+ocmCbRjYHpsTDEZFvn3
SHaFi5tmiiSqUqDNkvaMrvx7ShEZarQBOudU7VTr9L8Vg7Z0pH7cB3a8ermRhe65
41+2ZvZI0MfVLlADGxWI8VW0Fgy8FIuNkWlVDOTPTM57OQYkFBZ9cltz/AqpRS5x
PC8aZ/RjAXa3CRRslogQFaJ9EZd4oHdbjgNJVNWBOQd2B+oNaHI9fBiyjt+ogxOY
8NMRydrR6McRsBkHagJaet+MIOIhFGKV0hjSH/u2hEJVo/RcTQnlgtTnLaVGR56K
ksOOy2YBNwDyr16yKaqcQ6VDiul0CIQOTB7dXWGHWNmTeh82a9V4iRMBIpC2ExJ5
4F+si5YdhaAYERmBfnol
=1ALj
-----END PGP SIGNATURE-----

--nextPart7745603.2msArur1kl--

