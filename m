Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab3EUShU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:37:20 -0400
Received: from www.sr71.net ([198.145.64.142]:44013 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab3EUShS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:37:18 -0400
Message-ID: <519BBEDC.1030607@sr71.net>
Date: Tue, 21 May 2013 11:37:16 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 00/39] Transparent huge page cache
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2013 06:22 PM, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> It's version 4. You can also use git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git
> 
> branch thp/pagecache.
> 
> If you want to check changes since v3 you can look at diff between tags
> thp/pagecache/v3 and thp/pagecache/v4-prerebase.

What's the purpose of posting these patches?  Do you want them merged?
Or are they useful as they stand, or are they just here so folks can
play with them as you improve them?

> The goal of the project is preparing kernel infrastructure to handle huge
> pages in page cache.
> 
> To proof that the proposed changes are functional we enable the feature
> for the most simple file system -- ramfs. ramfs is not that useful by
> itself, but it's good pilot project. It provides information on what
> performance boost we should expect on other files systems.

Do you think folks would use ramfs in practice?  Or is this just a toy?
 Could this replace some (or all) existing hugetlbfs use, for instance?
