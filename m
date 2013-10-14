Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab3JNO1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:27:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:10063 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab3JNO1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:27:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,492,1378882800"; 
   d="scan'208";a="307533642"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20131001083828.GA8093@suse.de>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130924163740.4bc7db61e3e520798220dc4c@linux-foundation.org>
 <20130930100249.GB2425@suse.de>
 <20130930101029.GC2425@suse.de>
 <20130930185106.GD2125@tassilo.jf.intel.com>
 <20131001083828.GA8093@suse.de>
Subject: Re: [PATCHv6 00/22] Transparent huge page cache: phase 1, everything
 but mmap()
Content-Transfer-Encoding: 7bit
Message-Id: <20131014142732.0E067E0090@blue.fi.intel.com>
Date: Mon, 14 Oct 2013 17:27:32 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> I could be completely wrong here but these were the concerns I had when
> I first glanced through the patches. The changelogs had no information
> to convince me otherwise so I never dedicated the time to reviewing the
> patches in detail. I raised my concerns and then dropped it.

Okay. I got your point: more data from real-world workloads. I'll try to
bring some in next iteration.

-- 
 Kirill A. Shutemov
