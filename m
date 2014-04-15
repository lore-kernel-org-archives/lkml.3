Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaDOGEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 02:04:55 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:40637 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaDOGEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 02:04:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140414120600.GJ11096@twins.programming.kicks-ass.net>
References: <CAKohpom5Ft_XrNTExE9Ukyv1e4car+wicDiPp_Bdhy=PW9Sq8g@mail.gmail.com>
	<20140410143857.GA27654@localhost.localdomain>
	<CAKohpomMhpGsYGafr5uZ0QgO0MEndqDA4G=4syhus4sZW3d8cg@mail.gmail.com>
	<20140411145333.GC3438@localhost.localdomain>
	<20140411151825.GX11096@twins.programming.kicks-ass.net>
	<CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
	<20140414110245.GG11096@twins.programming.kicks-ass.net>
	<CAKohpo==1=K0=gZz_Z_Y0zO2PtyvA-Q67_+VKTJN7kbQgbiHTg@mail.gmail.com>
	<20140414114744.GI11096@twins.programming.kicks-ass.net>
	<CAKohpon=_ZR+QbfacGT+G_atgcc21KMYG3YxPf0nkSDLBH8Q2A@mail.gmail.com>
	<20140414120600.GJ11096@twins.programming.kicks-ass.net>
Date: Tue, 15 Apr 2014 11:34:53 +0530
Message-ID: <CAKohponxLG__ofjg0pig5yTfVnYWD6sVDmY6wo_Cc66ToP-G=w@mail.gmail.com>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 April 2014 17:36, Peter Zijlstra <peterz@infradead.org> wrote:
> That's a bit of a non-answer. I'm fairly sure its not a gazillion
> issues, since the actual scheduler tick doesn't actually do that much.
>
> So start by enumerating what is actually required.
>
> The 2), which I suppose you're now trying to implement is I think
> entirely the wrong way. The tick really assumes it runs local, moving it
> to another CPU is insane.

Yeah, I was trying this one :(

I still don't have enough knowledge of scheduler and so can't exactly
tell what all requires tick to fire a 1 second.

@Frederic: Can you please help :) ?

--
viresh
