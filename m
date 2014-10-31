Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbaJaN5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:57:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47979 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537AbaJaN5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:57:22 -0400
Date: Fri, 31 Oct 2014 14:57:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [rfcomm_run] WARNING: CPU: 0 PID: 95 at kernel/sched/core.c:7312
 __might_sleep()
Message-ID: <20141031135720.GL10501@worktop.programming.kicks-ass.net>
References: <20141027130621.GA6336@wfg-t540p.sh.intel.com>
 <20141027133627.GH3337@twins.programming.kicks-ass.net>
 <20141027140325.GA15725@wfg-t540p.sh.intel.com>
 <20141031121008.GK10501@worktop.programming.kicks-ass.net>
 <20141031131531.GA28258@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031131531.GA28258@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 09:15:31PM +0800, Fengguang Wu wrote:
> Nope. However I find some more bugs that happen around thermal_apic_exit. 
> One DEBUG_LOCKS_WARN_ON, one "task blocked for more than 120 seconds",
> and some RCU stalls. I just queued bisects for them. Hopefully we can
> get some results tomorrow.

Yeah, something is very sick there indeed... Hope it settles down and
goes away :-)
