Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaBNTTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:19:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbaBNTTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:19:51 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <20140214095011.GG27965@twins.programming.kicks-ass.net>
References: <20140207074405.GM5002@laptop.programming.kicks-ass.net>
	 <20140207165028.GO4250@linux.vnet.ibm.com>
	 <20140207165548.GR5976@mudshark.cambridge.arm.com>
	 <20140207180216.GP4250@linux.vnet.ibm.com>
	 <1391992071.18779.99.camel@triegel.csb>
	 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
	 <20140211155941.GU4250@linux.vnet.ibm.com>
	 <1392185194.18779.2239.camel@triegel.csb>
	 <20140212091907.GA3545@laptop.programming.kicks-ass.net>
	 <1392354475.18779.3849.camel@triegel.csb>
	 <20140214095011.GG27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Feb 2014 11:19:13 -0800
Message-ID: <1392405553.18779.4373.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 10:50 +0100, Peter Zijlstra wrote:
> On Thu, Feb 13, 2014 at 09:07:55PM -0800, Torvald Riegel wrote:
> > That depends on what your goal is.

First, I don't know why you quoted that, but without the context,
quoting it doesn't make sense.  Let me repeat the point.  The standard
is the rule set for the compiler.  Period.  The compiler does not just
serve the semantics that you might have in your head.  It does have to
do something meaningful for all of its users.  Thus, the goal for the
compiler is to properly compile programs in the language as specified.

If there is a deficiency in the standard (bug or missing feature) -- and
thus the specification, we need to have a patch for the standard that
fixes this deficiency.  If you think that this is the case, that's where
you fix it.

If your goal is to do wishful thinking, imagine some kind of semantics
in your head, and then assume that magically, implementations will do
just that, then that's bound to fail.

> A compiler that we don't need to fight in order to generate sane code
> would be nice. But as Linus said; we can continue to ignore you lot and
> go on as we've done.

I don't see why it's so hard to understand that you need to specify
semantics, and the place (or at least the base) for that is the
standard.  Aren't you guys the ones replying "send a patch"? :)

This isn't any different.  If you're uncomfortable working with the
standard, then say so, and reach out to people that aren't.

You can surely ignore the specification of the language(s) that you are
depending on.  But that won't help you.  If you want a change, get
involved.  (Oh, and claiming that the other side doesn't get it doesn't
count as getting involved.)

There's no fight between people here.  It's just a technical problem
that we have to solve in the right way.

