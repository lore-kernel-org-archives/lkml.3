Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaBNLEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:04:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaBNLEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:04:24 -0500
Date: Fri, 14 Feb 2014 11:04:19 +0000
From: Mel Gorman <mgorman@suse.de>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, riel@redhat.com,
        "'Minchan Kim'" <minchan@kernel.org>, weijie.yang.kh@gmail.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] mm/vmscan: restore sc->gfp_mask after promoting
 it to __GFP_HIGHMEM
Message-ID: <20140214110419.GA6732@suse.de>
References: <000101cf294f$eef39610$ccdac230$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <000101cf294f$eef39610$ccdac230$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 02:41:33PM +0800, Weijie Yang wrote:
> We promote sc->gfp_mask to __GFP_HIGHMEM to forcibly scan highmem if
> there are too many buffer_heads pinning highmem. see: cc715d99e5
> 
> This patch restores sc->gfp_mask to its caller original value after
> finishing the scan job, to avoid the impact on other invocations from
> its upper caller, such as vmpressure_prio(), shrink_slab().
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
