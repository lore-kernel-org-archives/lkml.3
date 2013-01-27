Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3A0ODk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 09:03:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:31434 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab3A0ODh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 09:03:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,546,1355126400"; 
   d="scan'208";a="278949811"
Message-ID: <510533B4.4070303@intel.com>
Date: Sun, 27 Jan 2013 22:03:32 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com> <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com> <510493E4.8060602@intel.com> <20130127104039.GC8894@pd.tnic>
In-Reply-To: <20130127104039.GC8894@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2013 06:40 PM, Borislav Petkov wrote:
> On Sun, Jan 27, 2013 at 10:41:40AM +0800, Alex Shi wrote:
>> Just rerun some benchmarks: kbuild, specjbb2005, oltp, tbench, aim9,
>> hackbench, fileio-cfq of sysbench, dbench, aiostress, multhreads
>> loopback netperf. on my core2, nhm, wsm, snb, platforms. no clear
>> performance change found.
> 
> Ok, good, You could put that in one of the commit messages so that it is
> there and people know that this patchset doesn't cause perf regressions
> with the bunch of benchmarks.

thanks suggestion!
