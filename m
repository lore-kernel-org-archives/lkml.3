Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3IZSSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:18:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:2908 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab3IZSSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:18:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,987,1371106800"; 
   d="scan'208";a="383983869"
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <20130926084010.GQ3081@twins.programming.kicks-ass.net>
References: <cover.1380144003.git.tim.c.chen@linux.intel.com>
	 <1380147049.3467.67.camel@schen9-DESK> <20130926064629.GB19090@gmail.com>
	 <20130926084010.GQ3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Sep 2013 11:18:42 -0700
Message-ID: <1380219522.3467.72.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 10:40 +0200, Peter Zijlstra wrote:
> On Thu, Sep 26, 2013 at 08:46:29AM +0200, Ingo Molnar wrote:
> > > +/*
> > > + * MCS lock defines
> > > + *
> > > + * This file contains the main data structure and API definitions of MCS lock.
> > 
> > A (very) short blurb about what an MCS lock is would be nice here.
> 
> A while back I suggested including a link to something like:
> 
> http://www.cise.ufl.edu/tr/DOC/REP-1992-71.pdf
> 
> Its a fairly concise write-up of the idea; only 6 pages. The sad part
> about linking to the web is that links tend to go dead after a while.

Link rot is a problem.  If I provide a few details about MCS lock I
think people should be able to google for it.

Tim



