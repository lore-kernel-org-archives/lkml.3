Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaBGEYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:24:33 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41257 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBGEYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:24:32 -0500
Date: Thu, 6 Feb 2014 20:24:27 -0800
From: Matt Wilson <msw@linux.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, mrushton@amazon.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        msw@amazon.com, Roger Pau Monne <roger.pau@citrix.com>
Subject: Re: [Xen-devel] [PATCH v2 0/4] xen-blk: bug fixes
Message-ID: <20140207042427.GA28057@u109add4315675089e695.ant.amazon.com>
References: <1391509575-3949-1-git-send-email-roger.pau@citrix.com>
 <20140204151501.GA1781@andromeda.dapyr.net>
 <20140206045729.GA15901@u109add4315675089e695.ant.amazon.com>
 <20140206162004.GA22864@konrad-lan.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206162004.GA22864@konrad-lan.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 11:20:04AM -0500, Konrad Rzeszutek Wilk wrote:
> On Wed, Feb 05, 2014 at 08:57:30PM -0800, Matt Wilson wrote:
> > On Tue, Feb 04, 2014 at 11:15:01AM -0400, Konrad Rzeszutek Wilk wrote:
> > > On Tue, Feb 04, 2014 at 11:26:11AM +0100, Roger Pau Monne wrote:
> > > > This series contain blkback bug fixes for memory leaks (patches 1 and 
> > > > 2) and a race (patch 3). Patch 4 removes blkif_request_segment_aligned 
> > > > since its memory layout is exactly the same as blkif_request_segment 
> > > > and should introduce no functional change.
> > > > 
> > > > All patches should be backported to stable branches, although the last 
> > > > one is not a functional change it will still be nice to have it for 
> > > > code correctness.
> > > 
> > > Matt and Matt, could you guys kindly take a look as well? Thank you!
> > 
> > Matt R. did some testing today and set up additional tests to run
> > overnight. He'll follow up after the overnight tests complete.
> 
> Thank you!

Just in case the various mailing list software ate Matt's messages, he
sent the following:

[PATCH v2 2/4] xen-blkback: fix memory leaks
Tested-by: Matt Rushton <mrushton@amazon.com>
Reviewed-by: Matt Rushton <mrushton@amazon.com>

[PATCH v2 3/4] xen-blkback: fix shutdown race
Tested-by: Matt Rushton <mrushton@amazon.com>
Reviewed-by: Matt Rushton <mrushton@amazon.com>

[PATCH v2 4/4] xen-blkif: drop struct blkif_request_segment_aligned
Tested-by: Matt Rushton <mrushton@amazon.com>

I've separately sent suggestions to Matt on how to setup his mailer to
format messages per list etiquette and how to avoid breaking message
threading.

--msw
