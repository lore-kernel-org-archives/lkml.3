Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3LPO0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:26:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:42381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab3LPO0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:26:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,495,1384329600"; 
   d="scan'208";a="445014487"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Jianguo Wu <wujianguo@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kirill.shutemov@linux.intel.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, qiuxishi <qiuxishi@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
In-Reply-To: <52AEC8FD.6050200@huawei.com>
References: <52AEC8FD.6050200@huawei.com>
Subject: RE: [PATCH] mm/hugetlb: check for pte NULL pointer in
 __page_check_address()
Content-Transfer-Encoding: 7bit
Message-Id: <20131216142513.784A8E0090@blue.fi.intel.com>
Date: Mon, 16 Dec 2013 16:25:13 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jianguo Wu wrote:
> In __page_check_address(), if address's pud is not present,
> huge_pte_offset() will return NULL, we should check the return value.
> 
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>

Looks okay to me.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Have you triggered a crash there? Or just spotted by reading the code?

-- 
 Kirill A. Shutemov
