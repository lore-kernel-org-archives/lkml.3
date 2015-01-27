Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbbA0IdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:33:04 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59143 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbbA0IdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:33:02 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 27 Jan 2015 17:34:19 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/page_alloc: expands broken freepage to proper
 buddy list when steal
Message-ID: <20150127083419.GF11358@js1304-P5Q-DELUXE>
References: <1418022980-4584-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1418022980-4584-3-git-send-email-iamjoonsoo.kim@lge.com>
 <54856F88.8090300@suse.cz>
 <20141210063840.GC13371@js1304-P5Q-DELUXE>
 <54C73FB5.30000@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C73FB5.30000@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 08:35:17AM +0100, Vlastimil Babka wrote:
> On 12/10/2014 07:38 AM, Joonsoo Kim wrote:
> > After your patch is merged, I will resubmit these on top of it.
> 
> Hi Joonsoo,
> 
> my page stealing patches are now in -mm so are you planning to resubmit this? At
> least patch 1 is an obvious bugfix, and patch 4 a clear compaction overhead
> reduction. Those don't need to wait for the rest of the series. If you are busy
> with other stuff, I can also resend those two myself if you want.

Hello,

I've noticed that your patches are merged. :)
If you are in hurry, you can resend them. I'm glad if you handle it.
If not, I will resend them, maybe, on end of this week.

In fact, I'm testing your stealing patches on my add-hoc fragmentation
benchmark. It would be finished soon and, after that, I can resend this
patchset.

Thanks.
