Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936057Ab3DKPLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:11:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:39614 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757765Ab3DKPLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:11:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,455,1363158000"; 
   d="scan'208";a="293528666"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <5166CEDD.9050301@oracle.com>
References: <51559150.3040407@oracle.com>
 <20130410080202.GB21292@blaptop>
 <5166CEDD.9050301@oracle.com>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
Content-Transfer-Encoding: 7bit
Message-Id: <20130411151323.89D40E0085@blue.fi.intel.com>
Date: Thu, 11 Apr 2013 18:13:23 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin wrote:
> On 04/10/2013 04:02 AM, Minchan Kim wrote:
> > I don't know this issue was already resolved. If so, my reply become a just
> > question to Kirill regardless of this BUG.
> 
> The issue is still reproducible with today's -next.

Could you share your kernel config and configuration of your virtual machine?

-- 
 Kirill A. Shutemov
