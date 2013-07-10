Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3GJR5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:57:38 -0400
Received: from one.firstfloor.org ([193.170.194.197]:60833 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab3GJR5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:57:37 -0400
Date: Wed, 10 Jul 2013 19:57:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com
Subject: Re: [PATCH v2 4/7] perf, x86: Save/resotre LBR stack during
 context switch
Message-ID: <20130710175734.GZ6123@two.firstfloor.org>
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com>
 <1372663387-11754-5-git-send-email-zheng.z.yan@intel.com>
 <20130704095735.GL18898@dyad.programming.kicks-ass.net>
 <20130704134457.GS6123@two.firstfloor.org>
 <20130704140057.GN18898@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704140057.GN18898@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 04:00:57PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 04, 2013 at 03:44:57PM +0200, Andi Kleen wrote:
> > Evidently it's not read-only on Haswell at least.
> 
> It would be ever so good if you could at least test run such patches against
> semi-current chips, not only the very latest.

So we tested some systems (old and new Atom, Westmere, Nehalem, *Bridge)
and they all have writable TOS. Also I double checked the SDM
and it actually documents these MSRs as R/W in Chapter 35

So relying on this is ok.

-Andi
