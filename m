Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaBGSp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:45:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaBGSp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:45:28 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <20140207165028.GO4250@linux.vnet.ibm.com>
References: <20140206134825.305510953@infradead.org>
	 <21984.1391711149@warthog.procyon.org.uk> <52F3DA85.1060209@arm.com>
	 <20140206185910.GE27276@mudshark.cambridge.arm.com>
	 <20140206192743.GH4250@linux.vnet.ibm.com>
	 <1391721423.23421.3898.camel@triegel.csb>
	 <20140206221117.GJ4250@linux.vnet.ibm.com>
	 <1391730288.23421.4102.camel@triegel.csb>
	 <20140207042051.GL4250@linux.vnet.ibm.com>
	 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
	 <20140207165028.GO4250@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Feb 2014 19:44:56 +0100
Message-ID: <1391798696.23421.4805.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 08:50 -0800, Paul E. McKenney wrote:
> On Fri, Feb 07, 2014 at 08:44:05AM +0100, Peter Zijlstra wrote:
> > On Thu, Feb 06, 2014 at 08:20:51PM -0800, Paul E. McKenney wrote:
> > > Hopefully some discussion of out-of-thin-air values as well.
> > 
> > Yes, absolutely shoot store speculation in the head already. Then drive
> > a wooden stake through its hart.
> > 
> > C11/C++11 should not be allowed to claim itself a memory model until that
> > is sorted.
> 
> There actually is a proposal being put forward, but it might not make ARM
> and Power people happy because it involves adding a compare, a branch,
> and an ISB/isync after every relaxed load...  Me, I agree with you,
> much preferring the no-store-speculation approach.

My vague recollection is that everyone agrees that out-of-thin-air
values shouldn't be allowed, but that it's surprisingly complex to
actually specify this properly.

However, the example that Peter posted further down in the thread seems
to be unrelated to out-of-thin-air.


