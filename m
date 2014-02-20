Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbaBTRbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:31:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:47339 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313AbaBTRbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:31:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,513,1389772800"; 
   d="scan'208";a="458962673"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: x86_pmu_start WARN_ON.
References: <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
	<20140217152859.GF15586@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
	<20140219101949.GG15586@twins.programming.kicks-ass.net>
	<alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
	<20140220100830.GN6835@laptop.programming.kicks-ass.net>
	<87r46xdbw4.fsf@tassilo.jf.intel.com>
	<20140220155416.GH9987@twins.programming.kicks-ass.net>
Date: Thu, 20 Feb 2014 09:31:19 -0800
In-Reply-To: <20140220155416.GH9987@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Thu, 20 Feb 2014 16:54:16 +0100")
Message-ID: <87mwhld72w.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> It will; trace_printk() works without -pg, I think you didn't read the
> instructions very well.

Ok, you enable and disable it again.  I won't guess why you do that.

>
> And there's a very good reason not to apply your patch; you can route
> the function tracer into perf, guess what happens when perf calls the
> function tracer again :-)

How? 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
