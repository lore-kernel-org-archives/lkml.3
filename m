Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3KAHgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:36:53 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:36378 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3KAHgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:36:52 -0400
Date: Fri, 1 Nov 2013 08:36:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Tom Weber <l_linux-kernel@mail2news.4t2.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC GIT PULL] NUMA-balancing memory corruption fixes
Message-ID: <20131101073648.GD21471@gmail.com>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
 <20131024122646.GB2402@suse.de>
 <20131031095143.GA9692@gmail.com>
 <CA+55aFyDve4RtZ6n11ghFcq1kmzs52OB+xetZjyP1q3RparUkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyDve4RtZ6n11ghFcq1kmzs52OB+xetZjyP1q3RparUkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Oct 31, 2013 at 2:51 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > ( If you think this is too dangerous for too little benefit then
> >   I'll drop this separate tree and will send the original commits in
> >   the merge window. )
> 
> Ugh. I hate hate hate the timing, and this is much larger and 
> scarier than what I'd like at this point, but I don't see the 
> point to delaying this either.

Yeah, it's pretty close to worst-case timing. I tried to accelerate 
the fixes as much as I dared, I wasn't even back from the KS yet but 
at another conference, doing all preparation and testing remotely
:-/ Still the timing sucks.

> So I'm pulling them. And then I may end up doing an rc8 after all.

Thanks for pulling them!

	Ingo
