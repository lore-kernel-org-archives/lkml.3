Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3A3IF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:05:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:44100 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab3A3IFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:05:54 -0500
Date: Tue, 29 Jan 2013 23:17:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 0/4] staging: zsmalloc: various cleanups/improvments
Message-ID: <20130130041739.GA24517@kroah.com>
References: <1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130128034740.GE3321@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128034740.GE3321@blaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 12:47:40PM +0900, Minchan Kim wrote:
> Hi Seth,
> 
> On Fri, Jan 25, 2013 at 11:46:14AM -0600, Seth Jennings wrote:
> > These patches are the first 4 patches of the zswap patchset I
> > sent out previously.  Some recent commits to zsmalloc and
> > zcache in staging-next forced a rebase. While I was at it, Nitin
> > (zsmalloc maintainer) requested I break these 4 patches out from
> > the zswap patchset, since they stand on their own.
> 
> [2/4] and [4/4] is okay to merge current zsmalloc in staging but
> [1/4] and [3/4] is dependent on zswap so it should be part of
> zswap patchset.

I tried to apply patches 2 and 4, but 2 didn't work, so I only applied
4/4.

thanks,

greg k-h
