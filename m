Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaESSMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:12:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbaESSMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:12:46 -0400
Message-ID: <537A4987.7040007@redhat.com>
Date: Mon, 19 May 2014 14:12:23 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>, akpm@linux-foundation.org,
        hannes@cmpxchg.org, shli@kernel.org, minchan@kernel.org,
        mgorman@suse.de, cmetcalf@tilera.com, aquini@redhat.com,
        mhocko@suse.cz, vdavydov@parallels.com, glommer@openvz.org,
        dchinner@redhat.com
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/vmscan.c: use DIV_ROUND_UP for calculation of zone's
 balance_gap and correct comments.
References: <1400472510-24375-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1400472510-24375-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 12:08 AM, Jianyu Zhan wrote:
> Currently, we use (zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
> KSWAPD_ZONE_BALANCE_GAP_RATIO to avoid a zero gap value. It's better to
> use DIV_ROUND_UP macro for neater code and clear meaning.
> 
> Besides, the gap value is calculated against the per-zone "managed pages",
> not "present pages". This patch also corrects the comment and do some
> rephrasing.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
