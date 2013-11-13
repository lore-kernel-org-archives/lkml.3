Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681Ab3KMSRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:17:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36335 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759032Ab3KMSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:16:53 -0500
Date: Wed, 13 Nov 2013 19:16:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Michel Lespinasse <walken@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: cache largest vma
Message-ID: <20131113181623.GS21461@twins.programming.kicks-ass.net>
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFwrtOaFtwGc6xyZH6-1j3f--AG1JS-iZM8-pZPnwRHBow@mail.gmail.com>
 <1383537862.2373.14.camel@buesod1.americas.hpqcorp.net>
 <20131104073640.GF13030@gmail.com>
 <1384143129.6940.32.camel@buesod1.americas.hpqcorp.net>
 <CANN689Eauq+DHQrn8Wr=VU-PFGDOELz6HTabGDGERdDfeOK_UQ@mail.gmail.com>
 <20131111120421.GB21291@gmail.com>
 <1384202848.6940.59.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384202848.6940.59.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 12:47:28PM -0800, Davidlohr Bueso wrote:
> On Mon, 2013-11-11 at 13:04 +0100, Ingo Molnar wrote:
> in find_vma() but the cost of maintaining it comes free. I just ran into
> a similar idea from 2 years ago:
> http://lkml.indiana.edu/hypermail/linux/kernel/1112.1/01352.html

Here's one from 2007:

http://programming.kicks-ass.net/kernel-patches/futex-vma-cache/vma_cache.patch

and I'm very sure Nick Piggin had one even older :-)


