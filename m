Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbbAZNr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:47:59 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:57392 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbbAZNr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:47:57 -0500
Date: Mon, 26 Jan 2015 15:47:51 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/2] clocksource: driver for Conexant Digicolor SoC
 timer
Message-ID: <20150126134751.GE3148@tarshish>
References: <cover.1422272518.git.baruch@tkos.co.il>
 <ad84f7155286c45401ff7f6bc6506407cc3beb61.1422272518.git.baruch@tkos.co.il>
 <54C644AF.9030208@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C644AF.9030208@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Mon, Jan 26, 2015 at 02:44:15PM +0100, Daniel Lezcano wrote:
> >diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> >index 94d90b24b56b..a993c108be67 100644
> >--- a/drivers/clocksource/Makefile
> >+++ b/drivers/clocksource/Makefile
> >@@ -10,6 +10,7 @@ obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
> >  obj-$(CONFIG_EM_TIMER_STI)	+= em_sti.o
> >  obj-$(CONFIG_CLKBLD_I8253)	+= i8253.o
> >  obj-$(CONFIG_CLKSRC_MMIO)	+= mmio.o
> >+obj-$(CONFIG_ARCH_DIGICOLOR)	+= timer-digicolor.o
> 
> Ah, one minor change I forgot to mention in the last review (sorry about
> that).
> 
> Don't depend on the ARCH, add and select a TIMER_DIGICOLOR (or whatever the
> name you prefer) in the mach-digicolor/Kconfig and use it here.

OK. I'll make the change. I'm just curious: what is the advantage of having a 
separate config symbol for the timer?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
