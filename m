Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751082AbaK0TtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:49:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:40258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaK0TtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:49:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="422411123"
Date: Thu, 27 Nov 2014 11:49:10 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        zheng.z.yan@intel.com, peterz@infradead.org, eranian@google.com
Subject: Re: perf/x86/intel/uncore: Add Haswell-EP uncore support
Message-ID: <20141127194910.GO10824@tassilo.jf.intel.com>
References: <20141013152950.11DE26610F1@gitolite.kernel.org>
 <20141125232050.GA9408@redhat.com>
 <20141126141422.GM10824@tassilo.jf.intel.com>
 <20141126152646.GA7984@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126152646.GA7984@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > > I'm wondering if these should be just wrmsr's instead of wrmsrl's.
>  > 
>  > Can we just shut up coverity please?
> 
> I can manually dismiss them, I don't think the checker has the
> information to determine this for itself.

I suspect my out of line MSR patchkit would fix the warning
as a side effect, because there would be a function call
inbetween and the function always gets full u64.

https://lkml.org/lkml/2014/10/10/376

So far it hasn't been reviewed. I'll keep reposting.

-Andi
