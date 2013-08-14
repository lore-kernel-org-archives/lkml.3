Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab3HNOmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:42:33 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52859 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab3HNOmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:42:32 -0400
Date: Wed, 14 Aug 2013 10:41:46 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        Ozgun Erdogan <ozgun@citusdata.com>, Metin Doslu <metin@citusdata.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] mm: workingset: keep shadow entries in check
Message-ID: <20130814144146.GA28858@cmpxchg.org>
References: <1375829050-12654-1-git-send-email-hannes@cmpxchg.org>
 <1375829050-12654-10-git-send-email-hannes@cmpxchg.org>
 <20130811235631.GO19750@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130811235631.GO19750@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andi!

On Mon, Aug 12, 2013 at 01:56:31AM +0200, Andi Kleen wrote:
> 
> I really like the idea of using the spare slots in the radix tree
> for something useful. It's amazing we haven't used that before.
> 
> I wonder if with some clever encoding even more information could be fit?

What do you have in mind?

> e.g. I assume you don't really need all bits of the refault distance,
> just a good enough approximation.
> 
> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only.
