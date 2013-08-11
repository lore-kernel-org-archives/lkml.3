Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab3HKX4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 19:56:36 -0400
Received: from one.firstfloor.org ([193.170.194.197]:37246 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab3HKX4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 19:56:33 -0400
Date: Mon, 12 Aug 2013 01:56:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
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
Message-ID: <20130811235631.GO19750@two.firstfloor.org>
References: <1375829050-12654-1-git-send-email-hannes@cmpxchg.org>
 <1375829050-12654-10-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375829050-12654-10-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I really like the idea of using the spare slots in the radix tree
for something useful. It's amazing we haven't used that before.

I wonder if with some clever encoding even more information could be fit?

e.g. I assume you don't really need all bits of the refault distance,
just a good enough approximation.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
