Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3IYJYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:24:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:20292 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab3IYJYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:24:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,977,1371106800"; 
   d="scan'208";a="383263810"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Ning Qu <quning@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CACz4_2drFs5LsM8mTFNOWGHAs0QbsNfHAhiBXJ7jM3qkGerd5w@mail.gmail.com>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
 <CACz4_2drFs5LsM8mTFNOWGHAs0QbsNfHAhiBXJ7jM3qkGerd5w@mail.gmail.com>
Subject: Re: [PATCHv6 00/22] Transparent huge page cache: phase 1, everything
 but mmap()
Content-Transfer-Encoding: 7bit
Message-Id: <20130925092355.E785EE0090@blue.fi.intel.com>
Date: Wed, 25 Sep 2013 12:23:55 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ning Qu wrote:
> Hi, Kirill,
> 
> Seems you dropped one patch in v5, is that intentional? Just wondering ...
> 
>   thp, mm: handle tail pages in page_cache_get_speculative()

It's not needed anymore, since we don't have tail pages in radix tree.

-- 
 Kirill A. Shutemov
