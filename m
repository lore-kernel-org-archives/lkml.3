Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaAPAUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:20:09 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:40808 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbaAPAUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:20:06 -0500
Date: Thu, 16 Jan 2014 02:20:01 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org, cl@linux-foundation.org
Subject: Re: [RFC][PATCH 5/9] mm: rearrange struct page
Message-ID: <20140116002001.GC8456@node.dhcp.inet.fi>
References: <20140114180042.C1C33F78@viggo.jf.intel.com>
 <20140114180055.21691733@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114180055.21691733@viggo.jf.intel.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 10:00:55AM -0800, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> To make the layout of 'struct page' look nicer, I broke
> up a few of the unions.  But, this has a cost: things that
> were guaranteed to line up before might not any more.  To make up
> for that, some BUILD_BUG_ON()s are added to manually check for
> the alignment dependencies.
> 
> This makes it *MUCH* more clear how the first few fields of
> 'struct page' get used by the slab allocators.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Looks much cleaner!

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
