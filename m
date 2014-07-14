Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbaGNRKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:10:43 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:47070 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbaGNRKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:10:36 -0400
Message-ID: <1405357829.2508.2.camel@j-VirtualBox>
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xie Miao <miaoxie1984@gmail.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Dave Chinner <david@fromorbit.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, miaox@cn.fujitsu.com
Date: Mon, 14 Jul 2014 10:10:29 -0700
In-Reply-To: <20140714095539.GP9918@twins.programming.kicks-ass.net>
References: <1404413420.8764.42.camel@j-VirtualBox>
	 <20140704010147.GY4453@dastard> <1404438366.8764.121.camel@j-VirtualBox>
	 <1404438890.8764.125.camel@j-VirtualBox>
	 <20140704075247.GZ19379@twins.programming.kicks-ass.net>
	 <1404463234.2457.4.camel@buesod1.americas.hpqcorp.net>
	 <1404532172.2572.30.camel@j-VirtualBox>
	 <CAAW_DMjgd5+EOvZX7_iZe-jHp=00Nf7MX3z6hBCRPgOfqnMtEA@mail.gmail.com>
	 <20140714095539.GP9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 11:55 +0200, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 05:37:13PM +0800, Xie Miao wrote:
> > Hi, Jason
> > 
> > Could you re-sent this patch? Because it seems it is ignored.
> 
> Its not ignored;

Right, I also noticed the patch in the git peterz/queue tree :)


