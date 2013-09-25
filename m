Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3IYP7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:59:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:43489 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab3IYP7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:59:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,978,1371106800"; 
   d="scan'208";a="383414984"
Subject: Re: [PATCH v5 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <20130925055556.GA3081@twins.programming.kicks-ass.net>
References: <cover.1380057198.git.tim.c.chen@linux.intel.com>
	 <1380061366.3467.54.camel@schen9-DESK>
	 <20130925055556.GA3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Sep 2013 08:58:53 -0700
Message-ID: <1380124733.3467.61.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 07:55 +0200, Peter Zijlstra wrote:
> On Tue, Sep 24, 2013 at 03:22:46PM -0700, Tim Chen wrote:
> > We will need the MCS lock code for doing optimistic spinning for rwsem.
> > Extracting the MCS code from mutex.c and put into its own file allow us
> > to reuse this code easily for rwsem.
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > ---
> >  kernel/mutex.c |   58 ++++++-------------------------------------------------
> >  1 files changed, 7 insertions(+), 51 deletions(-)
> 
> Wasn't this patch supposed to add include/linux/mcslock.h ?

Thanks for catching it.  I will correct it.

Tim

