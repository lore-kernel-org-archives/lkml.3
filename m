Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3FNIZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:25:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:19301 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab3FNIZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:25:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,864,1363158000"; 
   d="scan'208";a="254927220"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
In-Reply-To: <1371195041-26654-7-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1371195041-26654-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1371195041-26654-7-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: RE: [PATCH 7/8] mm/thp: fix doc for transparent huge zero page
Content-Transfer-Encoding: 7bit
Message-Id: <20130614082836.945E5E0090@blue.fi.intel.com>
Date: Fri, 14 Jun 2013 11:28:36 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanpeng Li wrote:
> Transparent huge zero page is used during the page fault instead of
> in khugepaged.
> 
> # ls /sys/kernel/mm/transparent_hugepage/
> defrag  enabled  khugepaged  use_zero_page
> # ls /sys/kernel/mm/transparent_hugepage/khugepaged/
> alloc_sleep_millisecs  defrag  full_scans  max_ptes_none  pages_collapsed  pages_to_scan  scan_sleep_millisecs
> 
> This patch corrects the documentation just like the codes done.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
