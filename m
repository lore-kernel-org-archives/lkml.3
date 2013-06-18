Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3FRHLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:11:25 -0400
Received: from ozlabs.org ([203.10.76.45]:37842 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab3FRHLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:11:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: A question on RCU vs. preempt-RCU
In-Reply-To: <20130617182023.GH32663@mtj.dyndns.org>
References: <20130616023611.GA19863@htj.dyndns.org> <8761xer1s8.fsf@rustcorp.com.au> <20130617182023.GH32663@mtj.dyndns.org>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 18 Jun 2013 14:51:13 +0930
Message-ID: <87obb4ngdy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:
> Buth yeah, interesting trick.  We'll be doing IPIs, flushing TLB and
> taking faults until it hits zero.  It'll all depend on the frequency
> of preemption but given that branches don't tend to be too expensive
> on modern processors, maybe it'd be a bit too hairy for possibly
> marginal gain?

Yeah, I'm not convinced either, but I am hoping some enthusiast will run
with the idea in hope of Fame and Glory :)

Cheers,
Rusty.
