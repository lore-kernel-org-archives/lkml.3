Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab3FQP2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:28:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:31204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab3FQP2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:28:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="256174581"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
In-Reply-To: <1370964919-16187-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1370964919-16187-1-git-send-email-kirill.shutemov@linux.intel.com>
Subject: RE: [PATCH 0/8] Transparent huge page cache: phase 0, prep work
Content-Transfer-Encoding: 7bit
Message-Id: <20130617153120.6EADFE0090@blue.fi.intel.com>
Date: Mon, 17 Jun 2013 18:31:20 +0300 (EEST)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> My patchset which introduces transparent huge page cache is pretty big and
> hardly reviewable. Dave Hansen suggested to split it in few parts.
> 
> This is the first part: preparation work. I think it's useful without rest
> patches.
> 
> There's one fix for bug in lru_add_page_tail(). I doubt it's possible to
> trigger it on current code, but nice to have it upstream anyway.
> Rest is cleanups.
> 
> Patch 8 depends on patch 7. Other patches are independent and can be
> applied separately.
> 
> Please, consider applying.

Andrew, Andrea, any feedback?

-- 
 Kirill A. Shutemov
