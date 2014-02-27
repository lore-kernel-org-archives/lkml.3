Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaB0ABw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:01:52 -0500
Received: from relay1.sgi.com ([192.48.179.29]:49239 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbaB0ABv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:01:51 -0500
Date: Wed, 26 Feb 2014 18:01:53 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        schwidefsky@de.ibm.com, rientjes@google.com, riel@redhat.com,
        pbonzini@redhat.com, mingo@kernel.org, mgorman@suse.de,
        kirill.shutemov@linux.intel.com, heiko.carstens@de.ibm.com,
        hannes@cmpxchg.org, gerald.schaefer@de.ibm.com, ebiederm@xmission.com,
        aarcange@redhat.com
Subject: Re: + mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
 added to -mm tree
Message-ID: <20140227000153.GC18555@sgi.com>
References: <530D9F50.1080400@de.ibm.com>
 <20140226145025.GA12571@redhat.com>
 <530E0306.7020601@de.ibm.com>
 <20140226153144.GA15527@redhat.com>
 <20140226165759.GB22802@laptop.programming.kicks-ass.net>
 <20140226172253.GQ3041@sgi.com>
 <20140226180603.GA25644@redhat.com>
 <530E4028.70903@de.ibm.com>
 <20140226193917.GR3041@sgi.com>
 <20140226152434.8faabadc7f4f8d6475d58f88@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226152434.8faabadc7f4f8d6475d58f88@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 03:24:34PM -0800, Andrew Morton wrote:
> On Wed, 26 Feb 2014 13:39:17 -0600 Alex Thorlton <athorlton@sgi.com> wrote:
> 
> > > 
> > > 
> > > > I'd suggest the patch below on top of your changes, but I won't argue.
> > 
> > I like this approach, and your updated comment as well.  This should
> > probably go in as [PATCH 2/4] in my series.  Do I need to spin a v5
> > with this new patch included in the series, or will Andrew pull this in?
> 
> Paolo's comments on Oleg's patch remain unaddressed, so please take a
> look at that and send out the final version?

Got it.  I'll get that to you tonight/tomorrow morning.

> An incremental patch would be preferred, please.  I'll later fold that
> into mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch to
> avoid any bisection holes.

Understood.  I'll keep them separate.

Thanks, Andrew!

- Alex
