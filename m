Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233AbaATGK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 01:10:59 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:51389 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaATGK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 01:10:57 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-13-52dcbdef5995
Date: Mon, 20 Jan 2014 15:12:02 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Xishi Qiu <qiuxishi@huawei.com>,
        riel@redhat.com, aquini@redhat.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: Improve documentation of page_order
Message-ID: <20140120061202.GB28712@bbox>
References: <520B0B75.4030708@huawei.com>
 <20130814085711.GK2296@suse.de>
 <20130814155205.GA2706@gmail.com>
 <20130814132602.814a88e991e29c5b93bbe22c@linux-foundation.org>
 <20130814222241.GQ2296@suse.de>
 <20140117143221.GA24851@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117143221.GA24851@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 02:32:21PM +0000, Mel Gorman wrote:
> Developers occasionally try and optimise PFN scanners by using page_order
> but miss that in general it requires zone->lock. This has happened twice for
> compaction.c and rejected both times.  This patch clarifies the documentation
> of page_order and adds a note to compaction.c why page_order is not used.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Except Laura pointed out,

Acked-by: Minchan Kim <minchan@kernel.org>

Thanks for following up this issue without forgetting.
-- 
Kind regards,
Minchan Kim
