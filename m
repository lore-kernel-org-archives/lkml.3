Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab3DXWvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:51:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48267 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758197Ab3DXWvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:51:52 -0400
Message-ID: <517861E0.7030801@zytor.com>
Date: Wed, 24 Apr 2013 15:51:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Sasha Levin <sasha.levin@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
References: <51559150.3040407@oracle.com> <20130410080202.GB21292@blaptop>
In-Reply-To: <20130410080202.GB21292@blaptop>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 01:02 AM, Minchan Kim wrote:
> 
> When I am looking at the code, I was wonder about the logic of GHZP(aka,
> get_huge_zero_page) reference handling. The logic depends on that page
> allocator never alocate PFN 0.
> 
> Who makes sure it? What happens if allocator allocates PFN 0?
> I don't know all of architecture makes sure it.
> You investigated it for all arches?
> 

This isn't manifest, right?  At least on x86 we should never, ever
allocate PFN 0.

	-hpa


