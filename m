Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3HFIsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:48:55 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42380 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3HFIsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:48:53 -0400
X-AuditID: 9c930179-b7c53ae000000457-36-5200b8733d46
Date: Tue, 6 Aug 2013 17:48:53 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 4/4] mm, page_alloc: optimize batch count in
 free_pcppages_bulk()
Message-ID: <20130806084852.GA22782@lge.com>
References: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375778620-31593-4-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375778620-31593-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 05:43:40PM +0900, Joonsoo Kim wrote:
> If we use a division operation, we can compute a batch count more closed
> to ideal value. With this value, we can finish our job within
> MIGRATE_PCPTYPES iteration. In addition, batching to free more pages
> may be helpful to cache usage.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Oops... Sorry.
Please ignore this one.
This patch is already submitted few seconds ago :)

Thanks.
