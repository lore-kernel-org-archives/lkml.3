Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab3JGSCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:02:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab3JGSCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:02:31 -0400
Message-ID: <5252F728.4010401@redhat.com>
Date: Mon, 07 Oct 2013 14:02:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/63] sched: numa: Slow scan rate if no NUMA hinting
 faults are being recorded
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-19-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-19-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:28 AM, Mel Gorman wrote:
> NUMA PTE scanning slows if a NUMA hinting fault was trapped and no page
> was migrated. For long-lived but idle processes there may be no faults
> but the scan rate will be high and just waste CPU. This patch will slow
> the scan rate for processes that are not trapping faults.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
