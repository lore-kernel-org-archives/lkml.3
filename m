Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3HQAwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:52:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57734 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3HQAwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:52:39 -0400
Date: Fri, 16 Aug 2013 21:46:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
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
Message-ID: <20130816194635.GB24092@twins.programming.kicks-ass.net>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
 <1376663644-153546-2-git-send-email-athorlton@sgi.com>
 <520E672C.3080102@intel.com>
 <20130816181728.GQ26093@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816181728.GQ26093@sgi.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 01:17:28PM -0500, Alex Thorlton wrote:
> I actually didn't write these patches (made a few tweaks to get them
> running on the latest kernel though).  They were submitted last July by 
> Peter Zijlstra. 

By Kirill, I don't think I've ever touched them.

> The messages from the original submission can be found here:
> https://lkml.org/lkml/2012/7/20/165

As can be seen by this posting you reference ;-)
