Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056AbaE3Q3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:29:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:24431 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202AbaE3Q3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:29:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,942,1392192000"; 
   d="scan'208";a="520310677"
Date: Fri, 30 May 2014 09:29:18 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, gleb@kernel.org, pbonzini@redhat.com,
        eranian@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] perf: Handle guest PEBS events with a fake event
Message-ID: <20140530162918.GD8876@tassilo.jf.intel.com>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-4-git-send-email-andi@firstfloor.org>
 <20140530073439.GB20167@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530073439.GB20167@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 09:34:39AM +0200, Peter Zijlstra wrote:
> On Thu, May 29, 2014 at 06:12:06PM -0700, Andi Kleen wrote:
> 
> > Note: in very rare cases with exotic events this may lead to spurious PMIs
> > in the guest.
> 
> Qualify that statement so that if someone runs into it we at least know
> it is known/expected.

You cannot actually observe it, so it's not a real problem.
I'll drop the Note.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
