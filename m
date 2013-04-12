Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab3DLC53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 22:57:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab3DLC52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 22:57:28 -0400
Message-ID: <516777DF.9090803@redhat.com>
Date: Thu, 11 Apr 2013 22:56:31 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] mm: vmscan: Move logic from balance_pgdat() to
 kswapd_shrink_zone()
References: <1365505625-9460-1-git-send-email-mgorman@suse.de> <1365505625-9460-11-git-send-email-mgorman@suse.de>
In-Reply-To: <1365505625-9460-11-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 07:07 AM, Mel Gorman wrote:
> balance_pgdat() is very long and some of the logic can and should
> be internal to kswapd_shrink_zone(). Move it so the flow of
> balance_pgdat() is marginally easier to follow.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
