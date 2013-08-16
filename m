Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab3HPEhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 00:37:31 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52543 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3HPEha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 00:37:30 -0400
Date: Fri, 16 Aug 2013 13:37:21 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hillf Danton <dhillf@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: compaction: Do not compact pgdat for order-0
Message-ID: <20130816043721.GB6216@gmail.com>
References: <CAJd=RBBF2h_tRpbTV6OkxQOfkvKt=ebn_PbE8+r7JxAuaFZxFQ@mail.gmail.com>
 <20130815104727.GT2296@suse.de>
 <20130815134139.GC8437@gmail.com>
 <20130815135627.GX2296@suse.de>
 <20130815141004.GD8437@gmail.com>
 <20130815153927.GZ2296@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815153927.GZ2296@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 04:39:27PM +0100, Mel Gorman wrote:
> If kswapd was reclaiming for a high order and resets it to 0 due to
> fragmentation it will still call compact_pgdat. For the most part, this will
> fail a compaction_suitable() test and not compact but it is unnecessarily
> sloppy. It could be fixed in the caller but fix it in the API instead.
> 
> [dhillf@gmail.com: Pointed out that it was a potential problem]
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
