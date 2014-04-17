Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbaDQJHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:07:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbaDQJHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:07:05 -0400
Date: Thu, 17 Apr 2014 10:06:55 +0100
From: Mel Gorman <mgorman@suse.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Linux-X86 <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Use an alternative to _PAGE_PROTNONE for _PAGE_NUMA
 v4
Message-ID: <20140417090655.GZ7292@suse.de>
References: <1397572876-1610-1-git-send-email-mgorman@suse.de>
 <20140417025912.GA7797@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140417025912.GA7797@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 10:59:12AM +0800, Fengguang Wu wrote:
> On Tue, Apr 15, 2014 at 03:41:13PM +0100, Mel Gorman wrote:
> > Fengguang Wu found that an earlier version crashed on his
> > tests. This version passed tests running with DEBUG_VM and
> > DEBUG_PAGEALLOC. Fengguang, another test would be appreciated and
> > if it helps this series is the mm-numa-use-high-bit-v4r3 branch in
> > git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma.git
> 
> Hi Mel,
> 
> We noticed the below changes. The last_state.is_incomplete_run 0=>1 change
> means the test box failed to boot up. Unfortunately we don't have
> serial console output of this testbox, it may be hard to check the
> root cause. Anyway, I'll try to bisect it to make the debug easier.
> 

The bisection will be pretty small and probably point to the last patch.
I assume that lkp-04 is the machine name. What sort of machine is it?
Does it have an unusual Kconfig that I might be missing a case for?
What userspace is it running? Maybe there is a chance I can duplicate
it. I assume fake/boot/1 is a test case that just boots the machine but
does it do anything else?

Thanks.

-- 
Mel Gorman
SUSE Labs
