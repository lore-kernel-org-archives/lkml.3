Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3AXKqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:46:07 -0500
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:56503 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753423Ab3AXKp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:45:59 -0500
Date: Thu, 24 Jan 2013 11:44:07 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        richard.genoud@gmail.com, linux-arm@overkiz.com, manabian@gmail.com,
        dgilbert@interlog.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Josh Wu <josh.wu@atmel.com>,
        Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 7/9] ARM: at91/at91_dt_defconfig: remove memory
 specification to cmdline
Message-ID: <20130124104407.GL7360@game.jcrosoft.org>
References: <cover.1358934163.git.nicolas.ferre@atmel.com>
 <2e06e92c758b768baaacc061aafa7f710b74ea02.1358934163.git.nicolas.ferre@atmel.com>
 <20130123102057.GJ7360@game.jcrosoft.org>
 <5100F4ED.9000004@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5100F4ED.9000004@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1208372076545944428
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrjeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrjeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:46 Thu 24 Jan     , Nicolas Ferre wrote:
> On 01/23/2013 11:20 AM, Jean-Christophe PLAGNIOL-VILLARD :
> > On 10:48 Wed 23 Jan     , Nicolas Ferre wrote:
> >> No need for this cmdline option as we are using DT.
> >> Moreover this defconfig is targeted to multiple SoC/boards: this option
> >> was nonsense.
> > just keep the console the rest is a nonsense too
> > 
> > as on 9g45 the initrd will be at 0x7xxxxxxx
> 
> Understood, but I prefer to keep a "root" option at least, so I keep it
> like this.
> 
> > the console too but as the patch serie to support via DT is not yet mainline
> > we can keep it
> 
> Ok for this.

I check and the default commande line in the defconfig is a nonsense now

as we will provide a default one via dt anyway

and the root option will not work on 9g45

so it's better to simply drop it

Best Regards,
J.
> 
> > 
> > Best Regards,
> > J.
> >>
> >> Reported-by: Josh Wu <josh.wu@atmel.com>
> >> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> >> ---
> >>  arch/arm/configs/at91_dt_defconfig | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/configs/at91_dt_defconfig b/arch/arm/configs/at91_dt_defconfig
> >> index b175577..a353ff6 100644
> >> --- a/arch/arm/configs/at91_dt_defconfig
> >> +++ b/arch/arm/configs/at91_dt_defconfig
> >> @@ -31,7 +31,7 @@ CONFIG_ZBOOT_ROM_TEXT=0x0
> >>  CONFIG_ZBOOT_ROM_BSS=0x0
> >>  CONFIG_ARM_APPENDED_DTB=y
> >>  CONFIG_ARM_ATAG_DTB_COMPAT=y
> >> -CONFIG_CMDLINE="mem=128M console=ttyS0,115200 initrd=0x21100000,25165824 root=/dev/ram0 rw"
> >> +CONFIG_CMDLINE="console=ttyS0,115200 initrd=0x21100000,25165824 root=/dev/ram0 rw"
> >>  CONFIG_KEXEC=y
> >>  CONFIG_AUTO_ZRELADDR=y
> >>  # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> >> -- 
> >> 1.8.0
> >>
> > 
> > 
> 
> 
> -- 
> Nicolas Ferre
