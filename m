Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3JJTai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:30:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab3JJTag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:30:36 -0400
Date: Thu, 10 Oct 2013 21:32:41 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi-mq updated to latest linux-block/new-queue
Message-ID: <20131010193240.GA17206@dhcp-26-207.brq.redhat.com>
References: <1381345971.19256.461.camel@haakon3.risingtidesystems.com>
 <20131009194658.GA3066@dhcp-26-207.brq.redhat.com>
 <20131010191714.GA3098@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010191714.GA3098@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 09:17:14PM +0200, Christoph Hellwig wrote:
> > What is the criteria for patches to include in your tree? I would suggest
> > to consider this one https://lkml.org/lkml/2013/8/9/90 if it fits.
> 
> For this one you probably want to send a patch to Jens to move blk-mq-tag.h
> to include/linux first instead of doing the relative include hack.

I wonder, if blk-mq- prefix should remain?.. This s code seems pretty much
generic to me.

> Also the  blk_mq_*tag* routines you use aren't exported, so a modular build of
> the driver with that patch applied will fail.

Yep, makes sense. Thanks for pointing out.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
