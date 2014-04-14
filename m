Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaDNJsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:48:41 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:45967 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaDNJsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:48:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
References: <CAKohpo=uT0oC+bZVJQPsoGLb-a4y4huYKtd1ayb4_+iH4906nw@mail.gmail.com>
	<CAKohpom5Ft_XrNTExE9Ukyv1e4car+wicDiPp_Bdhy=PW9Sq8g@mail.gmail.com>
	<20140410143857.GA27654@localhost.localdomain>
	<CAKohpomMhpGsYGafr5uZ0QgO0MEndqDA4G=4syhus4sZW3d8cg@mail.gmail.com>
	<20140411145333.GC3438@localhost.localdomain>
	<20140411151825.GX11096@twins.programming.kicks-ass.net>
	<CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
Date: Mon, 14 Apr 2014 15:18:30 +0530
Message-ID: <CAM4v1pOWQFNaoc44b+7=hrYEzwiMMnhVFZnqfJEZiECuiquuEQ@mail.gmail.com>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

I am not too sure about the complexity or the worthiness of this patch but
just wanted to add that care must be taken to migrate the tick_sched_timer
of all the remote CPUs off a hotplugged out CPU if the latter was keeping
their time thus far. In the normal scenario I am guessing the tick_sched_timer
dies along with the hotplugged out CPU since there is no need for it any more.

Regards
Preeti U Murthy
