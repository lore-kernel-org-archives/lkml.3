Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaA3CFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 21:05:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:54107 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaA3CFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 21:05:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,746,1384329600"; 
   d="scan'208";a="472995192"
Date: Wed, 29 Jan 2014 18:05:33 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
Message-ID: <20140130020533.GG9804@tassilo.jf.intel.com>
References: <20140130124201.d24b784b6483a11fe3057bd9@canb.auug.org.au>
 <20140130014914.GC9804@tassilo.jf.intel.com>
 <20140130125835.5b7809ec9dcaa040b690095f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130125835.5b7809ec9dcaa040b690095f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 12:58:35PM +1100, Stephen Rothwell wrote:
> Hi Andi,
> 
> On Wed, 29 Jan 2014 17:49:14 -0800 Andi Kleen <ak@linux.intel.com> wrote:
> >
> > > I fixed it up (see below) and can carry the fix as necessary (no action
> > > is required).
> > 
> > I don't think the fix is correct, both sysctls need to be kept. They
> > do different things.
> 
> The tip tree commit 52bf84aa206c ("sched/numa,mm: Remove
> p->numa_migrate_deferred") explicitly removed the
> numa_balancing_migrate_deferred sysctl.

Okay, sorry for the noise then.

-Andi
