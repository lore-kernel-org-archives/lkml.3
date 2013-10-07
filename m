Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3JGTLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:11:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab3JGTLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:11:05 -0400
Message-ID: <5253073C.7010205@redhat.com>
Date: Mon, 07 Oct 2013 15:10:52 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 46/63] mm: numa: Do not group on RO pages
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-47-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-47-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> And here's a little something to make sure not the whole world ends up
> in a single group.
> 
> As while we don't migrate shared executable pages, we do scan/fault on
> them. And since everybody links to libc, everybody ends up in the same
> group.
> 
> [riel@redhat.com: mapcount 1]
> Suggested-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
