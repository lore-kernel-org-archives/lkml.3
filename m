Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab3HPSRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:17:13 -0400
Received: from relay1.sgi.com ([192.48.179.29]:49210 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab3HPSRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:17:08 -0400
Date: Fri, 16 Aug 2013 13:17:28 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH 1/8] THP: Use real address for NUMA policy
Message-ID: <20130816181728.GQ26093@sgi.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
 <1376663644-153546-2-git-send-email-athorlton@sgi.com>
 <520E672C.3080102@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520E672C.3080102@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you add some actual descriptions to these patches that say why you
> are doing this, and why this particular patch is needed and implemented
> this way?
> 
> You mention that THP is slow for you, then go on to implement some
> non-cached page zero'ing, but you never quite connect the dots.

I actually didn't write these patches (made a few tweaks to get them
running on the latest kernel though).  They were submitted last July by 
Peter Zijlstra.  Andi Kleen suggested that I re-run some of my tests
using these patches to see whether they solved my issue.  I just
included my updated patches so that people could confirm that I'd pulled
them forward properly.

The messages from the original submission can be found here:
https://lkml.org/lkml/2012/7/20/165

I did write the patch that these were submitted in response to, to
control THP on a per-process basis, but it looks like we're probably
going to end up taking this in a different direction, pending some more
test results.

- Alex
