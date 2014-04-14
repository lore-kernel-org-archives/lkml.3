Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbaDNLwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:52:33 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:35692 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaDNLwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:52:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140414114744.GI11096@twins.programming.kicks-ass.net>
References: <CAKohpo=uT0oC+bZVJQPsoGLb-a4y4huYKtd1ayb4_+iH4906nw@mail.gmail.com>
	<CAKohpom5Ft_XrNTExE9Ukyv1e4car+wicDiPp_Bdhy=PW9Sq8g@mail.gmail.com>
	<20140410143857.GA27654@localhost.localdomain>
	<CAKohpomMhpGsYGafr5uZ0QgO0MEndqDA4G=4syhus4sZW3d8cg@mail.gmail.com>
	<20140411145333.GC3438@localhost.localdomain>
	<20140411151825.GX11096@twins.programming.kicks-ass.net>
	<CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
	<20140414110245.GG11096@twins.programming.kicks-ass.net>
	<CAKohpo==1=K0=gZz_Z_Y0zO2PtyvA-Q67_+VKTJN7kbQgbiHTg@mail.gmail.com>
	<20140414114744.GI11096@twins.programming.kicks-ass.net>
Date: Mon, 14 Apr 2014 17:22:30 +0530
Message-ID: <CAKohpon=_ZR+QbfacGT+G_atgcc21KMYG3YxPf0nkSDLBH8Q2A@mail.gmail.com>
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

On 14 April 2014 17:17, Peter Zijlstra <peterz@infradead.org> wrote:
> What causes this tick? I was under the impression that once there's a
> single task (not doing any syscalls) and the above issues are sorted, no
> more tick would happen.

This is what Frederic told me earlier:

https://lkml.org/lkml/2014/2/13/238
