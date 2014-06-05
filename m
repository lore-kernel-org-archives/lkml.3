Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaFEIiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:38:12 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:59951 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaFEIiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:38:09 -0400
Date: Thu, 5 Jun 2014 10:38:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v4] rwsem: Support optimistic spinning
Message-ID: <20140605083804.GF4926@gmail.com>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
 <1399055055.6275.15.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399055055.6275.15.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When trying to apply this patch again I noticed the following detail:

> From: Davidlohr Bueso <davidlohr@hp.com>
>
> [...]
>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

That's not a valid signoff sequence - the person sending the patch 
should be the last SOB.

I've changed it to:

 Based-on-work-from: Tim Chen <tim.c.chen@linux.intel.com>
 Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

which I suspect describes the intention of the SOB line fairly?

Thanks,

	Ingo
