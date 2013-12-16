Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3LPT1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:27:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab3LPT1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:27:07 -0500
Message-ID: <52AF5400.5080400@redhat.com>
Date: Mon, 16 Dec 2013 14:26:56 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] mm: page_alloc: Default allow file pages to use remote
 nodes for fair allocation policy
References: <1386943807-29601-1-git-send-email-mgorman@suse.de> <1386943807-29601-8-git-send-email-mgorman@suse.de>
In-Reply-To: <1386943807-29601-8-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 09:10 AM, Mel Gorman wrote:
> Indications from Johannes that he wanted this. Needs some data and/or justification why
> thrash protection needs it plus docs describing how MPOL_LOCAL is now different before
> it should be considered finished. I do not necessarily agree this patch is necessary
> but it's worth punting it out there for discussion and testing.

This seems like a sane default to me.

-- 
All rights reversed
