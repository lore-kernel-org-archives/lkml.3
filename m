Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbaE3QFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:05:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:37333 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378AbaE3QFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:05:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548985023"
Date: Fri, 30 May 2014 09:03:57 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, gleb@kernel.org, pbonzini@redhat.com,
        eranian@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] perf: Allow guest PEBS for KVM owned counters
Message-ID: <20140530160357.GB8876@tassilo.jf.intel.com>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-3-git-send-email-andi@firstfloor.org>
 <20140530073153.GA20167@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530073153.GA20167@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 09:31:53AM +0200, Peter Zijlstra wrote:
> On Thu, May 29, 2014 at 06:12:05PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Currently perf unconditionally disables PEBS for guest.
> > 
> > Now that we have the infrastructure in place to handle
> > it we can allow it for KVM owned guest events. For
> > the perf needs to know that a event is owned by
> > a guest. Add a new state bit in the perf_event for that.
> > 
> 
> This doesn't make sense; why does it need to be owned?

Please read the complete patch kit

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
