Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab3DUJ06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 05:26:58 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64654 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3DUJ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 05:26:57 -0400
Date: Sun, 21 Apr 2013 11:26:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux.com>, Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL v2] nohz: Posix cpu timers handling on full dynticks
Message-ID: <20130421092652.GA10292@gmail.com>
References: <1366383100-17053-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366383100-17053-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull this second version of the dynticks handling of posix cpu
> timers from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/nohz-posix-timers-v2
> 
> This fixes an issue with a race between run_posix_cpu_timers() and full
> dynticks CPUs that we found while discussing a patch with Olivier Langlois.
> 
> As a bonus, it also provides the other side of posix cpu timers handling
> in dynticks with the new helper to check before stopping the tick.
> 
> Thanks.
> 
> Frederic Weisbecker (3):
>   nohz: New APIs to re-evaluate the tick on full dynticks CPUs
>   posix_timers: Kick full dynticks CPUs when a posix cpu timer is armed
>   posix_timers: New API to prevent from stopping the tick when timers
>     are running
> 
>  include/linux/posix-timers.h |    2 +
>  include/linux/tick.h         |    4 ++
>  kernel/posix-cpu-timers.c    |   76 +++++++++++++++++++++++++++++++++---------
>  kernel/time/Kconfig          |    1 +
>  kernel/time/tick-sched.c     |   51 ++++++++++++++++++++++++++++
>  5 files changed, 118 insertions(+), 16 deletions(-)

Pulled, thanks Frederic!

	Ingo
