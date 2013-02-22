Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679Ab3BYVaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 16:30:18 -0500
Received: from ozlabs.org ([203.10.76.45]:56351 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928Ab3BYVaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 16:30:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, tglx@linutronix.de,
        peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        fweisbec@gmail.com, linux@arm.linux.org.uk, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        walken@google.com, vincent.guittot@linaro.org
Subject: Re: [PATCH v6 00/46] CPU hotplug: stop_machine()-free CPU hotplug
In-Reply-To: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com>
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 22 Feb 2013 11:01:46 +1030
Message-ID: <87mwuxfatp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
> Hi,
>
> This patchset removes CPU hotplug's dependence on stop_machine() from the CPU
> offline path and provides an alternative (set of APIs) to preempt_disable() to
> prevent CPUs from going offline, which can be invoked from atomic context.
> The motivation behind the removal of stop_machine() is to avoid its ill-effects
> and thus improve the design of CPU hotplug. (More description regarding this
> is available in the patches).

If you're doing a v7, please put your benchmark results somewhere!

The obvious place is in the 44/46.

Thanks,
Rusty.
