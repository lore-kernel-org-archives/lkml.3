Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab3ENVIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:08:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758264Ab3ENVIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:08:35 -0400
Message-ID: <5192A73F.3060606@redhat.com>
Date: Tue, 14 May 2013 17:06:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Michal Hocko <mhocko@suse.cz>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] mm: vmscan: Move logic from balance_pgdat() to kswapd_shrink_zone()
References: <1368432760-21573-1-git-send-email-mgorman@suse.de> <1368432760-21573-10-git-send-email-mgorman@suse.de>
In-Reply-To: <1368432760-21573-10-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 04:12 AM, Mel Gorman wrote:
> balance_pgdat() is very long and some of the logic can and should
> be internal to kswapd_shrink_zone(). Move it so the flow of
> balance_pgdat() is marginally easier to follow.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Rik van Riel <riel@redhat.com>

