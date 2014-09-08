Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaIHIP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:15:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbaIHIPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:15:25 -0400
Date: Mon, 8 Sep 2014 11:18:30 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] virtio_blk: merge S/G list entries by default
Message-ID: <20140908081830.GA32268@redhat.com>
References: <1410044994-14943-1-git-send-email-hch@lst.de>
 <20140907114153.GB26569@redhat.com>
 <20140907184745.GA23026@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140907184745.GA23026@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2014 at 08:47:45PM +0200, Christoph Hellwig wrote:
> On Sun, Sep 07, 2014 at 02:41:53PM +0300, Michael S. Tsirkin wrote:
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > OK so this is an optimization patch right?
> > What kind of performance gain is observed with it?
> 
> None.  I actually wrote it when the block layer had a bug when dm was
> used on top of the !merge case, and I decided to send it out as there had been
> no discussion about disabling this by default on the existing blk-mq
> drivers.
> 
> At least for my qemu/kvm setup it doesn't make a difference either way,
> although not doing the cheap merge doesn't like the right kind of optimization
> to me.

Could you respond to Ming Lei's mail, who benchmarked the patch, please?

-- 
MST
