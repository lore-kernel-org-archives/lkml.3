Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab3LPPUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:20:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab3LPPUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:20:20 -0500
Message-ID: <52AF1A22.1070708@redhat.com>
Date: Mon, 16 Dec 2013 10:20:02 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] mm: Annotate page cache allocations
References: <1386943807-29601-1-git-send-email-mgorman@suse.de> <1386943807-29601-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1386943807-29601-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 09:10 AM, Mel Gorman wrote:
> Annotations will be used for fair zone allocation policy. Patch is mostly
> taken from a link posted by Johannes on IRC. It's not perfect because all
> callers of these paths are not guaranteed to be allocating pages for page
> cache. However, it's probably close enough to cover all cases that matter
> with minimal distortion.
> 
> Not-signed-off

Whenever you and Johannes sign it off, you can add my

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
