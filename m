Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3CRJNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:13:15 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:56236 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3CRJNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:13:06 -0400
Date: Mon, 18 Mar 2013 10:13:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] sched: Cputime update for 3.10
Message-ID: <20130318091302.GB19068@gmail.com>
References: <1363196663-4258-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363196663-4258-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the latest cputime accounting updates that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	sched/core
> 
> HEAD: d9a3c9823a2e6a543eb7807fb3d15d8233817ec5
> 
> Some users are complaining that their threadgroup's runtime accounting freezes
> after a week or so of intense cpu-bound workload. This set tries to fix the issue
> by reducing the risk of multiplication overflow in the cputime scaling code.
> 
> Thanks.
> 
> ---
> Frederic Weisbecker (2):
>   math64: New div64_u64_rem helper
>   sched: Lower chances of cputime scaling overflow
> 
>  include/linux/math64.h |   19 ++++++++++++++++++-
>  kernel/sched/cputime.c |   46 ++++++++++++++++++++++++++++++++++------------
>  lib/div64.c            |   19 +++++++++++++------
>  3 files changed, 65 insertions(+), 19 deletions(-)

Pulled, thanks guys!

I Cc:-ed Linus, for the div64_u64_rem() helper to linux/math64.h and 
lib/dev64.c.

	Ingo
