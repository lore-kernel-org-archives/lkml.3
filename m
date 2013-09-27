Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3I0RvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:51:23 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42431 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab3I0RvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:51:19 -0400
Message-ID: <1380304277.30872.31.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH 4/4] [RFC] ipv6: Fix for possible ipv6 seqlock deadlock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Date: Fri, 27 Sep 2013 10:51:17 -0700
In-Reply-To: <5245AB9B.6040606@linaro.org>
References: <1380220464-28840-1-git-send-email-john.stultz@linaro.org>
	 <1380220464-28840-5-git-send-email-john.stultz@linaro.org>
	 <1380223848.3165.207.camel@edumazet-glaptop> <52448F0F.9050408@linaro.org>
	 <20130927054712.GB6597@gmail.com> <5245AB9B.6040606@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 09:00 -0700, John Stultz wrote:

> 
> It seems as such, so I'll add stable on my next submission.


Documentation/networking/netdev-FAQ.txt

Q: I see a network patch and I think it should be backported to stable.
   Should I request it via "stable@vger.kernel.org" like the references in
   the kernel's Documentation/stable_kernel_rules.txt file say?

A: No, not for networking.  Check the stable queues as per above 1st to see
   if it is already queued.  If not, then send a mail to netdev, listing
   the upstream commit ID and why you think it should be a stable candidate.

   Before you jump to go do the above, do note that the normal stable rules
   in Documentation/stable_kernel_rules.txt still apply.  So you need to
   explicitly indicate why it is a critical fix and exactly what users are
   impacted.  In addition, you need to convince yourself that you _really_
   think it has been overlooked, vs. having been considered and rejected.

   Generally speaking, the longer it has had a chance to "soak" in mainline,
   the better the odds that it is an OK candidate for stable.  So scrambling
   to request a commit be added the day after it appears should be avoided.


