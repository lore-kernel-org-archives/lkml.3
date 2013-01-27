Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3A0Khz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 05:37:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53718 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426Ab3A0Khx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 05:37:53 -0500
Date: Sun, 27 Jan 2013 11:40:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
Message-ID: <20130127104039.GC8894@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
	mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
	akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
	namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
	gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
	viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
 <20130124094439.GB13463@pd.tnic>
 <51014E34.60309@intel.com>
 <510493E4.8060602@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <510493E4.8060602@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 10:41:40AM +0800, Alex Shi wrote:
> Just rerun some benchmarks: kbuild, specjbb2005, oltp, tbench, aim9,
> hackbench, fileio-cfq of sysbench, dbench, aiostress, multhreads
> loopback netperf. on my core2, nhm, wsm, snb, platforms. no clear
> performance change found.

Ok, good, You could put that in one of the commit messages so that it is
there and people know that this patchset doesn't cause perf regressions
with the bunch of benchmarks.

> I also tested balance policy/powersaving policy with above benchmark,
> found, the specjbb2005 drop much 30~50% on both of policy whenever
> with openjdk or jrockit. and hackbench drops a lots with powersaving
> policy on snb 4 sockets platforms. others has no clear change.

I guess this is expected because there has to be some performance hit
when saving power...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
