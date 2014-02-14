Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaBNOQC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:16:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbaBNOQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:16:00 -0500
Message-ID: <52FE2511.1010004@redhat.com>
Date: Fri, 14 Feb 2014 09:15:45 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Weijie Yang <weijie.yang@samsung.com>, "'Mel Gorman'" <mgorman@suse.de>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>, weijie.yang.kh@gmail.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] mm/vmscan: restore sc->gfp_mask after promoting
 it to __GFP_HIGHMEM
References: <000101cf294f$eef39610$ccdac230$%yang@samsung.com>
In-Reply-To: <000101cf294f$eef39610$ccdac230$%yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 01:41 AM, Weijie Yang wrote:
> We promote sc->gfp_mask to __GFP_HIGHMEM to forcibly scan highmem if
> there are too many buffer_heads pinning highmem. see: cc715d99e5
> 
> This patch restores sc->gfp_mask to its caller original value after
> finishing the scan job, to avoid the impact on other invocations from
> its upper caller, such as vmpressure_prio(), shrink_slab().
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
