Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaFCDj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 23:39:59 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:14732 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbaFCDj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 23:39:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au2CAO1CjVN5LL1sPGdsb2JhbABZgwdSVYIeiwWdFgEBAQEBAQaQYoc5AYELFwMBAQEBODWCJQEBAQQBAjccIxAIAxgJJQ8FFBEDBxoTG4gmDtBbFxaFP4h9B4MrgRUElxyCY5Z4Ky8
Date: Tue, 3 Jun 2014 13:39:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Cc: Daniel Phillips <daniel@phunq.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
Message-ID: <20140603033940.GB14410@dastard>
References: <538B9DEE.20800@phunq.net>
 <538C360F.7020901@ontolinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538C360F.7020901@ontolinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 10:30:07AM +0200, Christian Stroetmann wrote:
> When I followed the advice of Dave Chinner:
> "We're not going to merge that page forking stuff (like you were
> told at LSF 2013 more than a year ago:
> http://lwn.net/Articles/548091/) without rigorous design review and
> a demonstration of the solutions to all the hard corner cases it
> has"
> given in his e-mail related with the presentation of the latest
> version of the Tux3 file system (see [1]) and read the linked
> article, I found in the second comments:
> "Parts of this almost sound like it either a.) overlaps with or b.)
> would benefit greatly from something similar to Featherstitch
> [[2]]."
> 
> Could it be that we have with Featherstitch a general solution
> already that is said to be even "file system agnostic"?
> Honestly, I thought that something like this would make its way into
> the Linux code base.

Here's what I said about the last proposal (a few months ago) for
integrating featherstitch into the kernel:

http://www.spinics.net/lists/linux-fsdevel/msg72799.html

It's not a viable solution.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
