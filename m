Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3IITxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:53:45 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34498 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab3IITxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:53:44 -0400
Date: Mon, 9 Sep 2013 14:53:35 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [RFC PATCH 2/4] mm: use mapcount for identifying zbud pages
Message-ID: <20130909195335.GF4701@variantweb.net>
References: <1377852176-30970-1-git-send-email-k.kozlowski@samsung.com>
 <1377852176-30970-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377852176-30970-3-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090919-8236-0000-0000-0000019952D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 10:42:54AM +0200, Krzysztof Kozlowski wrote:
> Currently zbud pages do not have any flags set so it is not possible to
> identify them during migration or compaction.
> 
> Implement PageZbud() by comparing page->_mapcount to -127 to distinguish
> pages allocated by zbud. Just like PageBuddy() is implemented.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

> ---
>  include/linux/mm.h |   23 +++++++++++++++++++++++
>  mm/zbud.c          |    4 ++++
>  2 files changed, 27 insertions(+)

