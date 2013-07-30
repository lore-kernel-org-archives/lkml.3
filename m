Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab3G3Vpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 17:45:52 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:28331 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab3G3Vpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 17:45:50 -0400
Message-ID: <1375220746.11122.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Performance regression from switching lock to rw-sem for
 anon-vma tree
From: Davidlohr Bueso <davidlohr@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, "Shi, Alex" <alex.shi@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>
Date: Tue, 30 Jul 2013 14:45:46 -0700
In-Reply-To: <1375216452.22432.422.camel@schen9-DESK>
References: <1372366385.22432.185.camel@schen9-DESK>
	 <1372375873.22432.200.camel@schen9-DESK> <20130628093809.GB29205@gmail.com>
	 <1372453461.22432.216.camel@schen9-DESK> <20130629071245.GA5084@gmail.com>
	 <1372710497.22432.224.camel@schen9-DESK> <20130702064538.GB3143@gmail.com>
	 <1373997195.22432.297.camel@schen9-DESK> <20130723094513.GA24522@gmail.com>
	 <20130723095124.GW27075@twins.programming.kicks-ass.net>
	 <20130723095306.GA26174@gmail.com> <1375143209.22432.419.camel@schen9-DESK>
	 <1375214394.11122.4.camel@buesod1.americas.hpqcorp.net>
	 <1375216452.22432.422.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 13:34 -0700, Tim Chen wrote:
> On Tue, 2013-07-30 at 12:59 -0700, Davidlohr Bueso wrote:
> > cc'ing Dave Chinner for XFS
> > 
> 
> Davidlohr,
> 
> I also wonder it this change benefit your workload.  Will
> be interested to know of your performance numbers.

Yep, I'm currently running some tests and will report when done.

> 
> Tim
> 


