Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3KFMxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:53:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:55339 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313Ab3KFMxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:53:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,647,1378882800"; 
   d="scan'208";a="423116133"
Date: Wed, 6 Nov 2013 20:53:45 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [virtio_blk] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:526
 sysfs_add_one()
Message-ID: <20131106125345.GA16685@localhost>
References: <20131104141012.GA17177@localhost>
 <527826A1.1060309@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527826A1.1060309@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Mon, Nov 04, 2013 at 03:58:41PM -0700, Jens Axboe wrote:
> On 11/04/2013 07:10 AM, Fengguang Wu wrote:
> > Hi Jens,
> > 
> > I'm not very sure about this bisect, but anyway it'd be good to inform
> > you of a possible problem on commit
> > 
> > commit 3a02db083a78c9f3c9b69305ab513f9422d91b08
> > Author: Jens Axboe <axboe@kernel.dk>
> > Date:   Fri May 24 20:22:33 2013 +0200
> > 
> >     virtio_blk: blk-mq support
> >     
> >     Pretend we have 4 issue queues.
> >     
> >     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> What git branch are you on? That one is outdated.

The commit is from block tree's new-queue and new-queue2 branches.
Yeah sorry these two branches are a bit old.

Thanks,
Fengguang
