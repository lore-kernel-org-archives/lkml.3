Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaJOUIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:08:10 -0400
Received: from mta-out1.inet.fi ([62.71.2.226]:34323 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbaJOUII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:08:08 -0400
Date: Wed, 15 Oct 2014 23:07:45 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: verify compound order when freeing a page
Message-ID: <20141015200745.GB17066@node.dhcp.inet.fi>
References: <1413400805-15547-1-git-send-email-yuzhao@google.com>
 <1413400805-15547-2-git-send-email-yuzhao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413400805-15547-2-git-send-email-yuzhao@google.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 12:20:05PM -0700, Yu Zhao wrote:
> This allows us to catch the bug fixed in the previous patch
> (mm: free compound page with correct order).
> 
> Here we also verify whether a page is tail page or not -- tail
> pages are supposed to be freed along with their head, not by
> themselves.
> 
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

I didn't give this tag. It's okay in this case, but please do not assume
that you've got Reviewed-by, unless the person said it explicitly.

> Signed-off-by: Yu Zhao <yuzhao@google.com>

Your Singed-off-by should come first.

-- 
 Kirill A. Shutemov
