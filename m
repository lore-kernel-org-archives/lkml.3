Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3HEHkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:40:52 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42697 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3HEHku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:40:50 -0400
X-AuditID: 9c930197-b7bfbae000000e88-a2-51ff5701510f
Date: Mon, 5 Aug 2013 16:41:00 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/4] mm, migrate: allocation new page lazyily in
 unmap_and_move()
Message-ID: <20130805074100.GE27240@lge.com>
References: <1375409279-16919-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375409279-16919-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20130802194102.GV715@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802194102.GV715@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> get_new_page() sets up result to communicate error codes from the
> following checks.  While the existing ones (page freed and thp split
> failed) don't change rc, somebody else might add a condition whose
> error code should be propagated back into *result but miss it.
> 
> Please leave get_new_page() where it is.  The win from this change is
> not big enough to risk these problems.

Hello, Johannes.

Okay. You are right. I will omit this patch next time.

Thanks.
