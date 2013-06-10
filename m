Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3FJPCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:02:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57644 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3FJPCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:02:19 -0400
Date: Mon, 10 Jun 2013 17:01:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: Re: [patch 0/9] sched: use runnable load avg in balance
Message-ID: <20130610150117.GA25238@laptop.programming.kicks-ass.net>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:20:43PM +0800, Alex Shi wrote:
> Peter&Ingo:

I'm tempted to apply 1-7; although I want to look them over in detail
once more; unfortunately (for you) I'm on PTO this week so it'll have to
be early next week.

As to patch 8, I really need/want buy-in from Paul on that; it removes
the entire point of the blocked load stuff.
