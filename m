Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbaBGNQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:16:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbaBGNQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:16:47 -0500
Message-ID: <52F4DCB0.7050500@redhat.com>
Date: Fri, 07 Feb 2014 08:16:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Ingo Molnar <mingo@kernel.org>, linux-mm@kvack.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 5/9] mm: Mark functions as static in migrate.c
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com> <2f62d7bb34ad1797b2990524239d4de90f8073a4.1391167128.git.rashika.kheria@gmail.com>
In-Reply-To: <2f62d7bb34ad1797b2990524239d4de90f8073a4.1391167128.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 07:08 AM, Rashika Kheria wrote:
> Mark functions as static in migrate.c because they are not used outside
> this file.
> 
> This eliminates the following warnings in mm/migrate.c:
> mm/migrate.c:1595:6: warning: no previous prototype for ‘numamigrate_update_ratelimit’ [-Wmissing-prototypes]
> mm/migrate.c:1619:5: warning: no previous prototype for ‘numamigrate_isolate_page’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
