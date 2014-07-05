Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaGEDOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 23:14:30 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:49198 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaGEDO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 23:14:29 -0400
Message-ID: <1404530065.2572.8.camel@j-VirtualBox>
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 04 Jul 2014 20:14:25 -0700
In-Reply-To: <1404463996.2457.10.camel@buesod1.americas.hpqcorp.net>
References: <1404413420.8764.42.camel@j-VirtualBox>
	 <20140704010147.GY4453@dastard> <1404438366.8764.121.camel@j-VirtualBox>
	 <1404438890.8764.125.camel@j-VirtualBox> <20140704061306.GK9508@dastard>
	 <1404457579.8764.161.camel@j-VirtualBox>
	 <1404463996.2457.10.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 01:53 -0700, Davidlohr Bueso wrote:
> On Fri, 2014-07-04 at 00:06 -0700, Jason Low 
> > Subject: [PATCH] rwsem: In rwsem_can_spin_on_owner(), return false if no owner
> 
> Could we change the subject to something more descriptive, ie:
> 
> rwsem: Allow conservative optimistic spinning for reader/writer paths

Sure, a Subject like this would better explain what is the effect of the
patch.

