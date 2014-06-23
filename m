Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaFWGu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:50:59 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34098 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaFWGu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:50:58 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 23 Jun 2014 15:51:41 +0900
From: Minchan Kim <minchan@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] mm: vmscan: move swappiness out of scan_control
Message-ID: <20140623065141.GD15594@bbox>
References: <1403282030-29915-1-git-send-email-hannes@cmpxchg.org>
 <1403282030-29915-4-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1403282030-29915-4-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 12:33:50PM -0400, Johannes Weiner wrote:
> Swappiness is determined for each scanned memcg individually in
> shrink_zone() and is not a parameter that applies throughout the
> reclaim scan.  Move it out of struct scan_control to prevent
> accidental use of a stale value.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
