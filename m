Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaBGNEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:04:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbaBGNER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:04:17 -0500
Message-ID: <52F4D9AE.7040401@redhat.com>
Date: Fri, 07 Feb 2014 08:03:42 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Ingo Molnar <mingo@kernel.org>, linux-mm@kvack.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 2/9] mm: Mark functions as static in memory.c
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com> <2bd9a806eae6958a75de452ba1d09f5cb6e2f7bc.1391167128.git.rashika.kheria@gmail.com>
In-Reply-To: <2bd9a806eae6958a75de452ba1d09f5cb6e2f7bc.1391167128.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 07:03 AM, Rashika Kheria wrote:
> Mark functions as static in memory.c because they are not used outside
> this file.
> 
> This eliminates the following warnings in mm/memory.c:
> mm/memory.c:3530:5: warning: no previous prototype for ‘numa_migrate_prep’ [-Wmissing-prototypes]
> mm/memory.c:3545:5: warning: no previous prototype for ‘do_numa_page’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
