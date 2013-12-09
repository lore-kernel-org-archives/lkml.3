Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761118Ab3LIOWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:22:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab3LIOWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:22:17 -0500
Message-ID: <52A5D20F.4010702@redhat.com>
Date: Mon, 09 Dec 2013 09:22:07 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/18] mm: numa: Do not clear PMD during PTE update scan
References: <1386572952-1191-1-git-send-email-mgorman@suse.de> <1386572952-1191-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1386572952-1191-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 02:08 AM, Mel Gorman wrote:
> If the PMD is flushed then a parallel fault in handle_mm_fault() will enter
> the pmd_none and do_huge_pmd_anonymous_page() path where it'll attempt
> to insert a huge zero page. This is wasteful so the patch avoids clearing
> the PMD when setting pmd_numa.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
