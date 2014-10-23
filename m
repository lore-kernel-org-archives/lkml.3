Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaJWGsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 02:48:37 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:36113 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaJWGsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 02:48:35 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: karam.lee@lge.com
Date: Thu, 23 Oct 2014 15:48:31 +0900
From: "karam.lee" <karam.lee@lge.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, ngupta@vflare.org,
        linux-kernel@vger.kernel.org, matthew.r.wilcox@intel.com,
        jmarchan@redhat.com, seungho1.park@lge.com
Subject: Re: [PATCH v5 0/3] zram: add rw_page implementation for zram and
 clean up unnecessary parameter
Message-ID: <20141023064831.GA5532@caribbean.org>
References: <1413967490-20218-1-git-send-email-karam.lee@lge.com>
 <20141022232022.GH21620@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022232022.GH21620@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 08:20:22AM +0900, Minchan Kim wrote:

Thank you for reply. Your advice was a big help!

I will send the fixed version.

> Hey Karam,
> 
> You could keep Acked-by/Reviewed-by gotten from me and Jerome
> in old versions if new version isn't changed heavily.
> It's credit of them and at least, you should respect it. :)
> 
> Please Cc Andrew for zram patches because he merges the patche
> into his tree (ie, mmotm).
> Oops but get_maintainer.pl -f drivers/block/zram doesn't say it. :(
> 
> Anyway, Thansk for nice work!
> 
> On Wed, Oct 22, 2014 at 05:44:46PM +0900, karam.lee@lge.com wrote:
> > From: "karam.lee" <karam.lee@lge.com>
> > 
> > Recently rw_page block device operation has been added.
> > This patchset implements rw_page operation for zram block device
> > and does some clean-up.
> > 
> > Patches 1~2 are for clean-up.
> > Patch 3 is for implementation of rw_page operation.
> > With the rw_page operation, zram can do I/O without allocating a BIO.
> > It make zram can save time and memory.
> > 
> > karam.lee (3):
> >   zram: remove bio parameter from zram_bvec_rw().
> >   zram: change parameter from vaild_io_request()
> >   zram: implement rw_page operation of zram
> 
> Acked-by: Minchan Kim <minchan@kernel.org>
> 
> -- 
> Kind regards,
> Minchan Kim
