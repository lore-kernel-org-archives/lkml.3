Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaEWJQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:16:45 -0400
Received: from mta-out1.inet.fi ([62.71.2.199]:56588 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaEWJQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:16:43 -0400
Date: Fri, 23 May 2014 12:16:31 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.15.0-rc6: VM_BUG_ON_PAGE(PageTail(page), page)
Message-ID: <20140523091631.GA4400@node.dhcp.inet.fi>
References: <20140522135828.GA24879@redhat.com>
 <537ECCDB.8080009@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537ECCDB.8080009@oracle.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 12:21:47AM -0400, Sasha Levin wrote:
> On 05/22/2014 09:58 AM, Dave Jones wrote:
> > Not sure if Sasha has already reported this on -next (It's getting hard
> > to keep track of all the VM bugs he's been finding), but I hit this overnight
> > on .15-rc6.  First time I've seen this one.
> 
> Unfortunately I had to disable transhuge/hugetlb in my testing .config since
> the open issues in -next get hit pretty often, and were unfixed for a while
> now.

What THP-related is not fixed by now? collapse hung? what else?

-- 
 Kirill A. Shutemov
