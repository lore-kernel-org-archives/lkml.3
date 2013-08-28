Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3H1TPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:15:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20823 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3H1TPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:15:13 -0400
Date: Wed, 28 Aug 2013 22:15:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kumar Gaurav <kumargauravgupta3@gmail.com>
Cc: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] xHCI: Fixing xhci_readl definition and function call
Message-ID: <20130828191500.GH19256@mwanda>
References: <1377482937-7486-1-git-send-email-kumargauravgupta3@gmail.com>
 <20130828071304.GO6329@mwanda>
 <521E1292.5060709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521E1292.5060709@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 08:39:06PM +0530, Kumar Gaurav wrote:
> On Wednesday 28 August 2013 12:43 PM, Dan Carpenter wrote:
> >On Mon, Aug 26, 2013 at 07:38:57AM +0530, Kumar Gaurav wrote:
> >>This patch redefine function xhci_readl.xhci_readl function doesn't use xhci_hcd argument.
> >>Hence there is no need of keeping it in the function arguments.
> >>
> >>Redefining this function breaks other functions which calls this function.
> >>This phatch also correct those calls in xhci driver.
> >>
> >>Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
> >>---
> >Could you put a list of changes since v2 here?:
> >
> >v3:  blah blah changelog mostly.
> >
> >Also this doesn't apply for me against linux-next.
> >
> >regards,
> >dan carpenter
> >
> There's no change from v2. I was sending the same patch again
> because the last one was lacking good description and i was told (or
> as i understood) that if I'm sending the same patch or patch for the
> same purpose as previous then i should increment version so i did.

Put:
v2: no change.  just the changelog.

Otherwise we have to look for the change.

> 
> I had developed this patch against linux-git, haven't tested that on
> linux-next as i haven't cloned  linux-next yet.
> 
> I've started cloning linux-next and as it's not applying on
> linux-next, I'll try it on linux-next (once i cloned it)  and will
> send again.

Yep.  Cleanups should be done against linux-next.

regards,
dan carpenter

