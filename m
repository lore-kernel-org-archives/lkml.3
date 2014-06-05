Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaFEQDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:03:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:21903 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbaFEQD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:03:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,981,1392192000"; 
   d="scan'208";a="523254286"
Subject: Re: [PATCH v4] rwsem: Support optimistic spinning
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
In-Reply-To: <20140605083804.GF4926@gmail.com>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	 <1399055055.6275.15.camel@buesod1.americas.hpqcorp.net>
	 <20140605083804.GF4926@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Jun 2014 09:03:07 -0700
Message-ID: <1401984187.2970.513.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-05 at 10:38 +0200, Ingo Molnar wrote:
> When trying to apply this patch again I noticed the following detail:
> 
> > From: Davidlohr Bueso <davidlohr@hp.com>
> >
> > [...]
> >
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> 
> That's not a valid signoff sequence - the person sending the patch 
> should be the last SOB.
> 
> I've changed it to:
> 
>  Based-on-work-from: Tim Chen <tim.c.chen@linux.intel.com>
>  Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> 
> which I suspect describes the intention of the SOB line fairly?
> 
> Thanks,
> 
> 	Ingo

It's fine with me.  Thanks.

Tim



