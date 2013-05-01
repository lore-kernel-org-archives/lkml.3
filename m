Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320Ab3EAMQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 08:16:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59780 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759910Ab3EAMQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 08:16:17 -0400
Date: Wed, 1 May 2013 14:14:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v4 0/6] sched: use runnable load based balance
Message-ID: <20130501121421.GA19602@dyad.programming.kicks-ass.net>
References: <1367040344-14485-1-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367040344-14485-1-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 01:25:38PM +0800, Alex Shi wrote:
> This patchset bases on tip/sched/core.
> 
> The patchset remove the burst wakeup detection which had worked fine on 3.8

Was this part of the original series from PJT or some patches afterwards?
I missed a few months worth of patches so any extra information to help me
catch up is greatly appreciated :-)

> kernel, since the aim7 is very imbalance. But rwsem write lock stealing 
> enabled in 3.9 kernel. aim7 imbalance disappeared. So the burst wakeup
> care doesn't needed. 

How does this follow.. surely something else can cause burst wakeups just fine
too?

> Peter, 
> Would you like to consider pick up the patchset? or give some comments? :)

I'll go read them.. :-)
