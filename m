Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab3JGTJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:09:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab3JGTJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:09:11 -0400
Message-ID: <525306C8.9000607@redhat.com>
Date: Mon, 07 Oct 2013 15:08:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 42/63] mm: numa: Change page last {nid,pid} into {cpu,pid}
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-43-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-43-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Change the per page last fault tracking to use cpu,pid instead of
> nid,pid. This will allow us to try and lookup the alternate task more
> easily. Note that even though it is the cpu that is store in the page
> flags that the mpol_misplaced decision is still based on the node.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
