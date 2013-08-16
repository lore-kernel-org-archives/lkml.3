Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3HPPEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:04:36 -0400
Received: from relay1.sgi.com ([192.48.179.29]:33069 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab3HPPEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:04:33 -0400
Date: Fri, 16 Aug 2013 10:04:53 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 0/8] Re: [PATCH] Add per-process flag to control thp
Message-ID: <20130816150453.GN26093@sgi.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
 <20130816144742.GZ24092@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816144742.GZ24092@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This 321.equake_l thing is not public, right? Do you have anything
> that
> is public that shows the same problem?

The quake test comes from the SPEC OMP benchmarks.  While I believe this
suite is available to anybody, I don't think it's free.  I was given
the test by our benchmarking team, I'll have to ask them if this is
publicly available/if they know of any publicly available tests that can
reproduce the issue.

> Do you have any idea where all the extra time is spend? 

I'm working on that as we speak.  I was trying to eliminate the
possibility that the vclear patches would help solve the problem,
before digging any deeper.  I should have some more information on
exactly where it's getting hung up in a few hours.

- Alex
