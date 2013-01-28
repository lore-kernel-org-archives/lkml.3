Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3A1XoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:44:09 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45405 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3A1XoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:44:07 -0500
X-AuditID: 9c930179-b7d01ae000004006-e2-51070d467a88
Date: Tue, 29 Jan 2013 08:44:06 +0900
From: Minchan Kim <minchan@kernel.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] staging: zsmalloc: various cleanups/improvments
Message-ID: <20130128234406.GC4752@blaptop>
References: <1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130128034740.GE3321@blaptop>
 <5106B03E.6070302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5106B03E.6070302@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 11:07:10AM -0600, Seth Jennings wrote:
> On 01/27/2013 09:47 PM, Minchan Kim wrote:
> > Hi Seth,
> > 
> > On Fri, Jan 25, 2013 at 11:46:14AM -0600, Seth Jennings wrote:
> >> These patches are the first 4 patches of the zswap patchset I
> >> sent out previously.  Some recent commits to zsmalloc and
> >> zcache in staging-next forced a rebase. While I was at it, Nitin
> >> (zsmalloc maintainer) requested I break these 4 patches out from
> >> the zswap patchset, since they stand on their own.
> > 
> > [2/4] and [4/4] is okay to merge current zsmalloc in staging but
> > [1/4] and [3/4] is dependent on zswap so it should be part of
> > zswap patchset.
> 
> Just to clarify, patches 1 and 3 are _not_ dependent on zswap.  They
> just introduce changes that are only needed by zswap.

I don't think so. If zswap might be not merged, we don't need [1, 3]
at the moment. You could argue that [1, 3] make zsmalloc more flexible
and I agree. BUT I want it when we have needs. It would be not too late.
So [1,3] should be part of zswap patchset.

> 
> Seth
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
