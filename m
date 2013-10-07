Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3JGTGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:06:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab3JGTG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:06:29 -0400
Message-ID: <52530627.7010000@redhat.com>
Date: Mon, 07 Oct 2013 15:06:15 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 36/63] mm: numa: Only trap pmd hinting faults if we would
 otherwise trap PTE faults
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-37-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-37-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> Base page PMD faulting is meant to batch handle NUMA hinting faults from
> PTEs. However, even is no PTE faults would ever be handled within a
> range the kernel still traps PMD hinting faults. This patch avoids the
> overhead.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
