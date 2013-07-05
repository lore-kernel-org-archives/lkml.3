Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3GEKqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:46:16 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59194 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab3GEKqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:46:12 -0400
Date: Fri, 5 Jul 2013 14:45:58 +0400
From: Artem Savkov <artem.savkov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Vrabel <david.vrabel@citrix.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org
Subject: Re: [tip:timers/core] hrtimers: Support resuming with two or more
 CPUs online (but stopped)
Message-ID: <20130705104558.GC4033@cpv436-motbuntu>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	David Vrabel <david.vrabel@citrix.com>,
	Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>, konrad.wilk@oracle.com,
	john.stultz@linaro.org, xen-devel@lists.xen.org
References: <1372329348-20841-2-git-send-email-david.vrabel@citrix.com>
 <tip-7c4c3a0f18ba57ea2a2985034532303d2929902a@git.kernel.org>
 <20130705093003.GA4033@cpv436-motbuntu>
 <51D69ACF.9020001@citrix.com>
 <alpine.DEB.2.02.1307051225060.11637@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1307051229190.32106@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307051229190.32106@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 12:36:50PM +0200, Thomas Gleixner wrote:
> On Fri, 5 Jul 2013, Thomas Gleixner wrote:
> > On Fri, 5 Jul 2013, David Vrabel wrote:
> > You failed to CC Artem :(
> Second thought.
> Where is that warning? Can't find it in neither in Linus tree nor in tip
> > > > [ 4363.083800] WARNING: CPU: 0 PID: 3977 at kernel/smp.c:385 smp_call_function_many+0xbd/0x2c0()
> All I see there is:
>         WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
>                      && !oops_in_progress && !early_boot_irqs_disabled);

It's in linux-next.git, not sure where it was merged from
commit 7f4a1d40a6311b7cb52d0f0061cb904d041c6dbc
Author: Chuansheng Liu <chuansheng.liu@intel.com>
Date:   Wed Jul 3 10:20:26 2013 +1000

    smp: Give WARN()ing when calling smp_call_function_many()/single() in serving irq


-- 
Regards,
    Artem
