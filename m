Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaBYSgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:36:35 -0500
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:56419 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaBYSge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:36:34 -0500
X-Greylist: delayed 60339 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2014 13:36:34 EST
Message-ID: <1393353389.2577.40.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] mm: per-thread vma caching
From: Davidlohr Bueso <davidlohr@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, aswin@hp.com,
        scott.norton@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Tue, 25 Feb 2014 10:36:29 -0800
In-Reply-To: <530CDFE0.10800@redhat.com>
References: <1393352206.2577.36.camel@buesod1.americas.hpqcorp.net>
	 <530CDFE0.10800@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 13:24 -0500, Rik van Riel wrote:
> On 02/25/2014 01:16 PM, Davidlohr Bueso wrote:
> 
> > The proposed approach is to keep the current cache and adding a small, per
> > thread, LRU cache. By keeping the mm->mmap_cache, 
> 
> This bit of the changelog may want updating :)

bah, yes thanks.


