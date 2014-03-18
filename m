Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbaCRQvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:51:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38224 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaCRQvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:51:08 -0400
Date: Tue, 18 Mar 2014 17:50:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        lsf@lists.linux-foundation.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [Lsf] [LSF/MM TOPIC] Testing Large-Memory Hardware
Message-ID: <20140318165059.GI22095@laptop.programming.kicks-ass.net>
References: <5328753B.2050107@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5328753B.2050107@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 09:32:59AM -0700, Dave Hansen wrote:
> I have a quick topic that could perhaps be addressed along with the
> testing topic that Dave Jones proposed.  I won't be attending, but there
> will be a couple of other Intel folks there.  This should be a fairly
> quick thing to address.
> 
> Topic:
> 
> Fengguang Wu who runs the wonderful LKP and 0day build tests was
> recently asking if I thought there was value in adding a large-memory
> system, say with 1TB of RAM.  LKP is the system that generates these
> kinds of automated bug reports and performance tests:
> 
> 	http://lkml.org/lkml/2014/3/9/201
> 
> My gut reaction was that we'd probably be better served by putting
> resources in to systems with higher core counts rather than lots of RAM.
>  I have encountered the occasional boot bug on my 1TB system, but it's
> far from a frequent occurrence, and even more infrequent to encounter
> things at runtime.
> 
> Would folks agree with that?  What kinds of tests, benchmarks, stress
> tests, etc... do folks run that are both valuable and can only be run on
> a system with a large amount of actual RAM?

We had a sched-numa + kvm fail on really large systems the other day,
but yeah in general such problems tend to be rare. Then again, without
test coverage they will always be rare, for even if there were problems,
nobody would notice :-)
