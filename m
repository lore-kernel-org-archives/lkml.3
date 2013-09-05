Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153Ab3IELZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:25:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:44498 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935586Ab3IELZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:25:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,846,1371106800"; 
   d="scan'208";a="291131837"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Jianguo Wu <wujianguo@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        kirill.shutemov@linux.intel.com, Mel Gorman <mgorman@suse.de>,
        xiaoguangrong@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <52283AF9.2080606@huawei.com>
References: <52283AF9.2080606@huawei.com>
Subject: RE: [PATCH v2][RESEND] mm/thp: fix stale comments of
 transparent_hugepage_flags
Content-Transfer-Encoding: 7bit
Message-Id: <20130905112524.CD222E0090@blue.fi.intel.com>
Date: Thu,  5 Sep 2013 14:25:24 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jianguo Wu wrote:
> Changelog:
>  *v1 -> v2: also update the stale comments about default transparent
> hugepage support pointed by Wanpeng Li.
> 
> Since commit 13ece886d9(thp: transparent hugepage config choice),
> transparent hugepage support is disabled by default, and
> TRANSPARENT_HUGEPAGE_ALWAYS is configured when TRANSPARENT_HUGEPAGE=y.
> 
> And since commit d39d33c332(thp: enable direct defrag), defrag is
> enable for all transparent hugepage page faults by default, not only in
> MADV_HUGEPAGE regions.
> 
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
