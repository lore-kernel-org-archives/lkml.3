Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbaGOCSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 22:18:13 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:63141 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671AbaGOCSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 22:18:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnsLAOuOxFN5LG3lPGdsb2JhbABZgw6DTYUIpHcBAQEBAQeXB4VmAYEPFwQBAQEBODWEBAEFOhwjEAgDGAklDwUlAwcaE4hBySIXGIVjhiEBgy4HhEMFmw2WIYFUKw
Date: Tue, 15 Jul 2014 12:17:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xie Miao <miaoxie1984@gmail.com>, Jason Low <jason.low2@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, miaox@cn.fujitsu.com
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
Message-ID: <20140715021732.GI22339@dastard>
References: <1404413420.8764.42.camel@j-VirtualBox>
 <20140704010147.GY4453@dastard>
 <1404438366.8764.121.camel@j-VirtualBox>
 <1404438890.8764.125.camel@j-VirtualBox>
 <20140704075247.GZ19379@twins.programming.kicks-ass.net>
 <1404463234.2457.4.camel@buesod1.americas.hpqcorp.net>
 <1404532172.2572.30.camel@j-VirtualBox>
 <CAAW_DMjgd5+EOvZX7_iZe-jHp=00Nf7MX3z6hBCRPgOfqnMtEA@mail.gmail.com>
 <20140714095539.GP9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714095539.GP9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 11:55:39AM +0200, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 05:37:13PM +0800, Xie Miao wrote:
> > Hi, Jason
> > 
> > Could you re-sent this patch? Because it seems it is ignored.
> 
> Its not ignored; its not merged because of unrelated stability issues.

Is it going to be merged? If not, can you please revert the
optimistic spinning patch that caused the regression?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
