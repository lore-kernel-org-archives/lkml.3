Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaIEGQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:16:49 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:40057 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaIEGQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:16:48 -0400
Date: Fri, 5 Sep 2014 08:16:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] nohz: Fix warning with perf on full dynticks
Message-ID: <20140905061643.GA26453@gmail.com>
References: <1409864325-4008-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409864325-4008-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the timers/urgent branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/urgent
> 
> HEAD: 40bea039593dfc7f3f9814dab844f6db43ae580b
> 
> Summary:
> 
> * A patch merged in this merge window turned the nohz full kick to
> become NMI-unsafe. But perf needs to use this kick from NMIs.
> This patch fixes the issue by restoring the old NMI-safe internals of
> the API.
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (1):
>       nohz: Restore NMI safe local irq work for local nohz kick
> 
> 
>  include/linux/tick.h     |  7 +------
>  kernel/time/tick-sched.c | 14 ++++++++++++++
>  2 files changed, 15 insertions(+), 6 deletions(-)

Pulled into tip:timers/urgent, thanks Frederic!

	Ingo
