Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaJPNka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:40:30 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42047 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbaJPNk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:40:29 -0400
Date: Thu, 16 Oct 2014 09:40:22 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20141016134022.GB9180@phnom.home.cmpxchg.org>
References: <20141016155657.1b4ea40d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016155657.1b4ea40d@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 03:56:57PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (powerpc
> allyesconfig) failed like this:

[...]

> include/linux/page_counter.h:19:27: error: 'LONG_MAX' undeclared (first use in this function)
> include/linux/page_counter.h:19:38: error: 'PAGE_SIZE' undeclared (first use in this function)

[...]

> Caused by commit 36a1bfb2a772 ("mm: memcontrol: lockless page
> counters").  See Rule 1 in Documentation/SubmitChecklist.

I'll be in the corner.

> I have added the following patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 16 Oct 2014 15:49:08 +1100
> Subject: [PATCH] mm: memcontrol: add includes for page_counter.h
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks, Stephen.  I just sent a similar patch in reply to Fengguang's
build bot, either version should do.
