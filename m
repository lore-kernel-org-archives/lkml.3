Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab3KOJ5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 04:57:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab3KOJ5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:57:40 -0500
Date: Fri, 15 Nov 2013 09:57:31 +0000
From: Mel Gorman <mgorman@suse.de>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dave.jiang@intel.com,
        akpm@linux-foundation.org, dhillf@gmail.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH 1/2] mm: hugetlbfs: Add some VM_BUG_ON()s to catch
 non-hugetlbfs pages
Message-ID: <20131115095731.GC26002@suse.de>
References: <20131114233357.90EE35C1@viggo.jf.intel.com>
 <20131114233358.2B10EA33@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131114233358.2B10EA33@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 03:33:58PM -0800, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Dave Jiang reported that he was seeing oopses when running
> NUMA systems and default_hugepagesz=1G.  I traced the issue down
> to migrate_page_copy() trying to use the same code for hugetlb
> pages and transparent hugepages.  It should not have been trying
> to pass thp pages in there.
> 
> So, add some VM_BUG_ON()s for the next hapless VM developer that
> tries the same thing.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
