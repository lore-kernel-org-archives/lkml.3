Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab3IYJvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:51:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:7810 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab3IYJvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:51:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,977,1371106800"; 
   d="scan'208";a="383272383"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20130924163740.4bc7db61e3e520798220dc4c@linux-foundation.org>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130924163740.4bc7db61e3e520798220dc4c@linux-foundation.org>
Subject: Re: [PATCHv6 00/22] Transparent huge page cache: phase 1, everything
 but mmap()
Content-Transfer-Encoding: 7bit
Message-Id: <20130925095105.06464E0090@blue.fi.intel.com>
Date: Wed, 25 Sep 2013 12:51:04 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 23 Sep 2013 15:05:28 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > It brings thp support for ramfs, but without mmap() -- it will be posted
> > separately.
> 
> We were never going to do this :(
> 
> Has anyone reviewed these patches much yet?

Dave did very good review. Few other people looked to separate patches.
See Reviewed-by/Acked-by tags in patches.

It looks like most mm experts are busy with numa balancing nowadays, so
it's hard to get more review.

The patchset was mostly ignored for few rounds and Dave suggested to split
to have less scary patch number.

> > Please review and consider applying.
> 
> It appears rather too immature at this stage.

More review is always welcome and I'm committed to address issues.

-- 
 Kirill A. Shutemov
