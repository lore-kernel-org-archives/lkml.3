Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbaE2GpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:45:10 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46298 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbaE2GpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:45:06 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 29 May 2014 15:48:10 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] CMA: use MIGRATE_SYNC in alloc_contig_range()
Message-ID: <20140529064810.GA7044@js1304-P5Q-DELUXE>
References: <1401344750-3684-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20140529063505.GH10092@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529063505.GH10092@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 03:35:05PM +0900, Minchan Kim wrote:
> On Thu, May 29, 2014 at 03:25:50PM +0900, Joonsoo Kim wrote:
> > Before commit 'mm, compaction: embed migration mode in compact_control'
> > from David is merged, alloc_contig_range() used sync migration,
> > instead of sync_light migration. This doesn't break anything currently
> > because page isolation doesn't have any difference with sync and
> > sync_light, but it could in the future, so change back as it was.
> > 
> > And pass cc->mode to migrate_pages(), instead of passing MIGRATE_SYNC
> > to migrate_pages().
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Acked-by: Minchan Kim <minchan@kernel.org>

Thanks.

> 
> Hello Joonsoo,
> 
> Please Ccing me if you send patch related to CMA mm part.
> I have reviewed/fixed mm part of CMA for a long time so worth to Cced
> although I always don't have a time to look at it. :)

Okay! This is just small fix going back orignal, so I didn't cc many people
related to CMA mm part. Anyway, I'm sorry.

Thanks.
