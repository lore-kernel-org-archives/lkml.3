Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3LMPrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:47:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab3LMPrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:47:07 -0500
Message-ID: <52AB2BEE.8040303@redhat.com>
Date: Fri, 13 Dec 2013 10:46:54 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] mm: page_alloc: Break out zone page aging distribution
 into its own helper
References: <1386943807-29601-1-git-send-email-mgorman@suse.de> <1386943807-29601-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1386943807-29601-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 09:10 AM, Mel Gorman wrote:
> This patch moves the decision on whether to round-robin allocations between
> zones and nodes into its own helper functions. It'll make some later patches
> easier to understand and it will be automatically inlined.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
