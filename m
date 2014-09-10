Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaIJQka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:40:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbaIJQk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:40:29 -0400
Date: Wed, 10 Sep 2014 19:43:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] virtio_blk: merge S/G list entries by default
Message-ID: <20140910164337.GD14199@redhat.com>
References: <1410044994-14943-1-git-send-email-hch@lst.de>
 <20140907114153.GB26569@redhat.com>
 <20140907184745.GA23026@lst.de>
 <20140908081830.GA32268@redhat.com>
 <20140908201557.GA1378@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908201557.GA1378@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 10:15:57PM +0200, Christoph Hellwig wrote:
> On Mon, Sep 08, 2014 at 11:18:30AM +0300, Michael S. Tsirkin wrote:
> > Could you respond to Ming Lei's mail, who benchmarked the patch, please?
> 
> I don't really have any additional data or disagreement, not sure what
> I should respond there.

Hmm Ming Lei measured a slowdown with your patch.
Is that expected?
