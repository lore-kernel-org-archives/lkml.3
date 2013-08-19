Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750734Ab3HSD2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 23:28:51 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:40326 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3HSD2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 23:28:50 -0400
Date: Mon, 19 Aug 2013 06:28:46 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add the generic sched_clock under
 timekeeping
Message-ID: <20130819032846.GH3922@tarshish>
References: <a38977cc6608170b69b21b8a5ee985685c7e8a0d.1374055149.git.baruch@tkos.co.il>
 <51E6E91C.1090700@linaro.org>
 <20130717191222.GW6950@tarshish>
 <51E6EEA8.7040504@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E6EEA8.7040504@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Wed, Jul 17, 2013 at 12:21:12PM -0700, John Stultz wrote:
> On 07/17/2013 12:12 PM, Baruch Siach wrote:
> >On Wed, Jul 17, 2013 at 11:57:32AM -0700, John Stultz wrote:
> >>On 07/17/2013 03:05 AM, Baruch Siach wrote:
> >>>Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> >>>---
> >>>  MAINTAINERS | 2 ++
> >>>  1 file changed, 2 insertions(+)
> >>>
> >>>diff --git a/MAINTAINERS b/MAINTAINERS
> >>>index bf61e04..bd9616a 100644
> >>>--- a/MAINTAINERS
> >>>+++ b/MAINTAINERS
> >>>@@ -7129,6 +7129,7 @@ M:	Thomas Gleixner <tglx@linutronix.de>
> >>>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
> >>>  S:	Supported
> >>>  F:	include/linux/clocksource.h
> >>>+F:	include/linux/sched_clock.h
> >>>  F:	include/linux/time.h
> >>>  F:	include/linux/timex.h
> >>>  F:	include/uapi/linux/time.h
> >>>@@ -7136,6 +7137,7 @@ F:	include/uapi/linux/timex.h
> >>>  F:	kernel/time/clocksource.c
> >>>  F:	kernel/time/time*.c
> >>>  F:	kernel/time/ntp.c
> >>>+F:	kernel/time/sched_clock.c
> >>It seems like we could probably simplify this bit to kernel/time/*, no?
> >This would add jiffies.c and all the tick-* files that are currently covered
> >by the "HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS" section.
> 
> Ok, fair enough. My thought was it all goes through Thomas anyway,
> but for those sections there are different combinations of folks who
> co-maintain.

So would you take it for v3.12?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
