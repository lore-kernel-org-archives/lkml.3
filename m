Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936465Ab3DJOIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:08:12 -0400
Received: from a194-210.smtp-out.amazonses.com ([199.255.194.210]:40179 "EHLO
	a194-210.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759112Ab3DJOIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:08:10 -0400
Date: Wed, 10 Apr 2013 14:08:08 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC GIT PULL] nohz: Kconfig layout improvements
In-Reply-To: <CAFTL4hyToYPCsKUrQmtUxeN+X7=40vS9vnB0_nk8X+6-vm_KSQ@mail.gmail.com>
Message-ID: <0000013df44667bc-a362bd49-dc4f-47c3-9220-87f54bf7d079-000000@email.amazonses.com>
References: <1364993190-13784-1-git-send-email-fweisbec@gmail.com> <0000013dd63de989-c6980852-2aac-4597-ba34-3b2efaa24c17-000000@email.amazonses.com> <CAFTL4hyToYPCsKUrQmtUxeN+X7=40vS9vnB0_nk8X+6-vm_KSQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Frederic Weisbecker wrote:

> I don't know which tree you are using. But if you have that patch in:

This is tip timers/nohz

> http://git.kernel.org/cgit/linux/kernel/git/frederic/linux-dynticks.git/commit/?h=3.9-rc1-nohz1&id=451128553e5e827dccc6cbcd24238470ec693d90
> looking at the traces on that CPU may give you a few hints. Then you can
> dig deeper by looking at the sched_switch, timers, irq, ... events

The last time when I checked this before testing this rev it turned out
that nr_running was always > 1. Traces did only show that the timer
interrupt was still on. I added printks to figure out what was up at that
time which was a bit awkward since the kernel is a bit sensitive about
doing printks in these functions.

Sadly, I am suffering from manageritis these days and probably wont have
the time to get into this again for the next two weeks.



