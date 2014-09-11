Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaIKTVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 15:21:51 -0400
Received: from one.firstfloor.org ([193.170.194.197]:56696 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaIKTVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 15:21:50 -0400
Date: Thu, 11 Sep 2014 21:21:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: BUG uncore_assign_events
Message-ID: <20140911192148.GO4120@two.firstfloor.org>
References: <20140910091626.GO16043@twins.programming.kicks-ass.net>
 <20140910215908.GL4120@two.firstfloor.org>
 <20140911002956.5e4aa1d9@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911002956.5e4aa1d9@as>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hwc->idx is not 64 -- it's 0xd000064

> The bt insn is causing a page fault 27 MB past c->idxmsk

Ah true. Thanks.

However I don't think it changes the conclusion. Likely
the box pointer is wrong.

-Andi

> 
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
