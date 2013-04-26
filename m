Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab3DZBad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 21:30:33 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62294 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759079Ab3DZBac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:30:32 -0400
X-AuditID: 9c93016f-b7c3dae000000592-2f-5179d8b7f04a
Date: Fri, 26 Apr 2013 10:30:30 +0900
From: Minchan Kim <minchan@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
Message-ID: <20130426013030.GA26691@blaptop>
References: <51559150.3040407@oracle.com>
 <20130410080202.GB21292@blaptop>
 <517861E0.7030801@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517861E0.7030801@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello hpa,

On Wed, Apr 24, 2013 at 03:51:12PM -0700, H. Peter Anvin wrote:
> On 04/10/2013 01:02 AM, Minchan Kim wrote:
> > 
> > When I am looking at the code, I was wonder about the logic of GHZP(aka,
> > get_huge_zero_page) reference handling. The logic depends on that page
> > allocator never alocate PFN 0.
> > 
> > Who makes sure it? What happens if allocator allocates PFN 0?
> > I don't know all of architecture makes sure it.
> > You investigated it for all arches?
> > 
> 
> This isn't manifest, right?  At least on x86 we should never, ever
> allocate PFN 0.

Thanks for the confirm.

-- 
Kind regards,
Minchan Kim
