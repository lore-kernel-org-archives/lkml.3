Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab3JOPRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:17:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59325 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3JOPRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:17:48 -0400
Date: Tue, 15 Oct 2013 09:17:47 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: Send BLK_TN_PROCESS events to all running
 traces
Message-ID: <20131015151747.GL541@kernel.dk>
References: <1379449831-6710-1-git-send-email-jack@suse.cz>
 <20130923113723.GA9623@quack.suse.cz>
 <20131015094035.GA12416@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015094035.GA12416@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15 2013, Jan Kara wrote:
> On Mon 23-09-13 13:37:23, Jan Kara wrote:
> > On Tue 17-09-13 22:30:31, Jan Kara wrote:
> > > Currently each task sends BLK_TN_PROCESS event to the first traced
> > > device it interacts with after a new trace is started. When there are
> > > several traced devices and the task accesses more devices, this logic
> > > can result in BLK_TN_PROCESS being sent several times to some devices
> > > while it is never sent to other devices. Thus blkparse doesn't display
> > > command name when parsing some blktrace files.
> > > 
> > > Fix the problem by sending BLK_TN_PROCESS event to all traced devices
> > > when a task interacts with any of them.
> >   Jens, any opinion about this?
>   Jens, ping? I guess this patch fell through cracks...

Queued up for 3.13, thanks!

-- 
Jens Axboe

