Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab3KFOca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:32:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57385 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab3KFOc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:32:29 -0500
Date: Wed, 6 Nov 2013 15:32:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: lockref: Use bloated_spinlocks to avoid explicit config
 dependencies
Message-ID: <20131106143214.GP10651@twins.programming.kicks-ass.net>
References: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20131105150145.734a5dd5b5d455800ebfa0d3@linux-foundation.org>
 <20131105224217.GC20167@shutemov.name>
 <20131105155619.021f32eba1ca8f15a73ed4c9@linux-foundation.org>
 <20131105231310.GE20167@shutemov.name>
 <20131106093131.GU28601@twins.programming.kicks-ass.net>
 <20131106111845.GG26785@twins.programming.kicks-ass.net>
 <20131106133112.GB22132@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106133112.GB22132@shutemov.name>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 03:31:12PM +0200, Kirill A. Shutemov wrote:
> Should we get rid of CONFIG_CMPXCHG_LOCKREF completely and have here:
> 
> #if defined(CONFIG_ARCH_USE_CMPXCHG_LOCKREF) && \
> 	defined(CONFIG_SMP) && !BLOATED_SPINLOCKS
> 

Yeah, that might make more sense.
