Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaBFQUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:20:37 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42627 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaBFQUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:20:36 -0500
Date: Thu, 6 Feb 2014 11:20:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matt Wilson <msw@linux.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, mrushton@amazon.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        msw@amazon.com, Roger Pau Monne <roger.pau@citrix.com>
Subject: Re: [Xen-devel] [PATCH v2 0/4] xen-blk: bug fixes
Message-ID: <20140206162004.GA22864@konrad-lan.dumpdata.com>
References: <1391509575-3949-1-git-send-email-roger.pau@citrix.com>
 <20140204151501.GA1781@andromeda.dapyr.net>
 <20140206045729.GA15901@u109add4315675089e695.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206045729.GA15901@u109add4315675089e695.ant.amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 08:57:30PM -0800, Matt Wilson wrote:
> On Tue, Feb 04, 2014 at 11:15:01AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Tue, Feb 04, 2014 at 11:26:11AM +0100, Roger Pau Monne wrote:
> > > This series contain blkback bug fixes for memory leaks (patches 1 and 
> > > 2) and a race (patch 3). Patch 4 removes blkif_request_segment_aligned 
> > > since its memory layout is exactly the same as blkif_request_segment 
> > > and should introduce no functional change.
> > > 
> > > All patches should be backported to stable branches, although the last 
> > > one is not a functional change it will still be nice to have it for 
> > > code correctness.
> > 
> > Matt and Matt, could you guys kindly take a look as well? Thank you!
> 
> Matt R. did some testing today and set up additional tests to run
> overnight. He'll follow up after the overnight tests complete.

Thank you!
> 
> --msw
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
