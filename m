Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3JGTXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:23:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:59405 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab3JGTW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:22:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1051,1371106800"; 
   d="scan'208";a="406793287"
Date: Mon, 7 Oct 2013 12:22:58 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@redhat.com, jolsa@redhat.com,
        zheng.z.yan@intel.com
Subject: Re: [PATCH v1 1/2] perf,x86: add Intel RAPL PMU support
Message-ID: <20131007192258.GC3363@tassilo.jf.intel.com>
References: <1381162158-24329-1-git-send-email-eranian@google.com>
 <1381162158-24329-2-git-send-email-eranian@google.com>
 <20131007175542.GB3363@tassilo.jf.intel.com>
 <20131007180810.GJ3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007180810.GJ3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 08:08:10PM +0200, Peter Zijlstra wrote:
> On Mon, Oct 07, 2013 at 10:55:42AM -0700, Andi Kleen wrote:
> > This would in principle allow making it a module later (if perf ever
> > supports that)
> 
> IIRC its a few EXPORTs away from being able to do that.

Great. With ~700k text that would be a good thing.
After all most users don't develop.

Hopefully we can get there soon.

Is anyone actively working on it?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
