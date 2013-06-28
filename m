Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab3F1OCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:02:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52176 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab3F1OCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:02:52 -0400
Date: Fri, 28 Jun 2013 16:02:45 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        roger.pau@citrix.com
Subject: Re: [GIT PULL) (xen) stable/for-jens-3.10 - Patches for Linux 3.11
Message-ID: <20130628140245.GK24293@kernel.dk>
References: <20130624133652.GA21369@phenom.dumpdata.com>
 <20130628130015.GA3284@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628130015.GA3284@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28 2013, Konrad Rzeszutek Wilk wrote:
> On Mon, Jun 24, 2013 at 09:36:52AM -0400, Konrad Rzeszutek Wilk wrote:
> > Hey Jens,
> > 
> > I have a branch ready for v3.11 (the same that was for v3.10) with
> > tons of fixes in it. There are some extra fixes that we are working
> > through - but they are little one-line fixes (sanity checks).
> 
> The extra fix is now in the tree, which means that the diffstat has an
> extra patch:
> 
> 
>  drivers/block/xen-blkback/blkback.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> The full diffstat should look like this now:
> 
>  Documentation/ABI/testing/sysfs-driver-xen-blkback |  17 +
>  .../ABI/testing/sysfs-driver-xen-blkfront          |  10 +
>  drivers/block/xen-blkback/blkback.c                | 872 +++++++++++++--------
>  drivers/block/xen-blkback/common.h                 | 147 +++-
>  drivers/block/xen-blkback/xenbus.c                 |  85 ++
>  drivers/block/xen-blkfront.c                       | 532 ++++++++++---
>  include/xen/interface/io/blkif.h                   |  53 ++
>  include/xen/interface/io/ring.h                    |   5 +
>  8 files changed, 1299 insertions(+), 422 deletions(-)
> 
> Please pull and also if possible include below the nice blurb. Thanks!

Thanks, pulled.


-- 
Jens Axboe

