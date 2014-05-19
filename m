Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaESCKI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 22:10:08 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:54392 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaESCKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 22:10:07 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 19 May 2014 11:12:34 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Mel Gorman <mgorman@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "'Tomasz Stanislawski'" <t.stanislaws@samsung.com>
Subject: Re: [RFC PATCH 0/3] Aggressively allocate the pages on cma reserved
 memory
Message-ID: <20140519021234.GB19615@js1304-P5Q-DELUXE>
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com>
 <536CCC78.6050806@samsung.com>
 <20140513022603.GF23803@js1304-P5Q-DELUXE>
 <8738gcae4h.fsf@linux.vnet.ibm.com>
 <20140515021055.GC10116@js1304-P5Q-DELUXE>
 <20140515094718.GE23991@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515094718.GE23991@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:47:18AM +0100, Mel Gorman wrote:
> On Thu, May 15, 2014 at 11:10:55AM +0900, Joonsoo Kim wrote:
> > > That doesn't always prefer CMA region. It would be nice to
> > > understand why grouping in pageblock_nr_pages is beneficial. Also in
> > > your patch you decrement nr_try_cma for every 'order' allocation. Why ?
> > 
> > pageblock_nr_pages is just magic value with no rationale. :)
> 
> I'm not following this discussions closely but there is rational to that
> value -- it's the size of a huge page for that architecture.  At the time
> the fragmentation avoidance was implemented this was the largest allocation
> size of interest.

Hello,

Indeed. There is a such good rationale.
Really thanks for informing it.

Thanks.
