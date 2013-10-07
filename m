Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3JGPM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:12:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab3JGPMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:12:51 -0400
Message-ID: <5252CF5A.4000003@redhat.com>
Date: Mon, 07 Oct 2013 11:12:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/63] mm: Do not flush TLB during protection change if
 !pte_present && !migration_entry
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-11-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-11-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:28 AM, Mel Gorman wrote:
> NUMA PTE scanning is expensive both in terms of the scanning itself and
> the TLB flush if there are any updates. Currently non-present PTEs are
> accounted for as an update and incurring a TLB flush where it is only
> necessary for anonymous migration entries. This patch addresses the
> problem and should reduce TLB flushes.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
