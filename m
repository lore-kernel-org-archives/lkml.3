Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3AOGqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:46:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49804 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3AOGqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:46:18 -0500
Date: Tue, 15 Jan 2013 07:46:15 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.8 - bug-fixes.
Message-ID: <20130115064615.GC30331@kernel.dk>
References: <20130114205001.GA6879@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130114205001.GA6879@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14 2013, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please git pull the following branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.8
> 
> which has a couple of fixes that should have been pulled some time ago (my mistake
> on not posting this earlier). There is one serious fix in there from Roger
> which allows the blkback to handle bio's with partial data. Without that patch
> the LVM operations on guests can fail (and often do). Please pull!
> 
> Thanks!
> 
>  drivers/block/xen-blkback/blkback.c | 18 ++++++++------
>  drivers/block/xen-blkback/xenbus.c  | 49 ++++++++++++++++++-------------------
>  drivers/block/xen-blkfront.c        | 10 +++++---
>  include/linux/llist.h               | 25 +++++++++++++++++++
>  4 files changed, 66 insertions(+), 36 deletions(-)

Did you forget to push it out?

-- 
Jens Axboe

