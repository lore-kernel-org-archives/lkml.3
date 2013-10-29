Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab3J2OJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:09:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49717 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab3J2OJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:09:46 -0400
Date: Tue, 29 Oct 2013 15:09:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH 0/4] Lockdep enablement for seqcount/seqlocks (v2)
Message-ID: <20131029140926.GE16117@laptop.programming.kicks-ass.net>
References: <1381186321-4906-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381186321-4906-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 03:51:57PM -0700, John Stultz wrote:
> Just wanted to send this out again for further feedback.
> 
> This patch series enables lockdep for seqcount/seqlock structures,
> as well as provides the required cleanups to explicitly initialize
> the seqcount structures on u64_stat_sync users.
> 
> In addition the last two patches in this provide fixes to
> some of the issues the new lockdep infrastructure caught.
> 
> I'd greatly appreciate any thoughts or feedback on the series!
> Particularly on how the u64_stats_sync initialization changes
> should be merged.

I've picked up all 4 patches for the lockdep tree; I've tried against
-next of today (20131029) and found no collisions with networking so I'm
hoping all will land well.

Please anybody holler if they disagree/want things done differently.
