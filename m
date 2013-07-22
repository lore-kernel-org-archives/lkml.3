Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab3GVTvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:51:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820Ab3GVTvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:51:35 -0400
Message-ID: <51ED8D33.7050900@redhat.com>
Date: Mon, 22 Jul 2013 15:51:15 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] mm: page_alloc: rearrange watermark checking in get_page_from_freelist
References: <1374267325-22865-1-git-send-email-hannes@cmpxchg.org> <1374267325-22865-3-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1374267325-22865-3-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 04:55 PM, Johannes Weiner wrote:
> Allocations that do not have to respect the watermarks are rare
> high-priority events.  Reorder the code such that per-zone dirty
> limits and future checks important only to regular page allocations
> are ignored in these extraordinary situations.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
