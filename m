Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaGNJz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:55:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:51216 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaGNJzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:55:51 -0400
Date: Mon, 14 Jul 2014 11:55:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Xie Miao <miaoxie1984@gmail.com>
Cc: Jason Low <jason.low2@hp.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Dave Chinner <david@fromorbit.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, miaox@cn.fujitsu.com
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
Message-ID: <20140714095539.GP9918@twins.programming.kicks-ass.net>
References: <1404413420.8764.42.camel@j-VirtualBox>
 <20140704010147.GY4453@dastard>
 <1404438366.8764.121.camel@j-VirtualBox>
 <1404438890.8764.125.camel@j-VirtualBox>
 <20140704075247.GZ19379@twins.programming.kicks-ass.net>
 <1404463234.2457.4.camel@buesod1.americas.hpqcorp.net>
 <1404532172.2572.30.camel@j-VirtualBox>
 <CAAW_DMjgd5+EOvZX7_iZe-jHp=00Nf7MX3z6hBCRPgOfqnMtEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAW_DMjgd5+EOvZX7_iZe-jHp=00Nf7MX3z6hBCRPgOfqnMtEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 05:37:13PM +0800, Xie Miao wrote:
> Hi, Jason
> 
> Could you re-sent this patch? Because it seems it is ignored.

Its not ignored; its not merged because of unrelated stability issues.
