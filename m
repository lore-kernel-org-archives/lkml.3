Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab3JYNv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:51:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36264 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab3JYNv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:51:57 -0400
Date: Fri, 25 Oct 2013 14:51:54 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio_blk: blk-mq support
Message-ID: <20131025135154.GD2815@kernel.dk>
References: <20131025130459.730903511@bombadil.infradead.org>
 <20131025130735.637242058@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025130735.637242058@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25 2013, Christoph Hellwig wrote:
> Switch virtio-blk from the dual support for old-style requests and bios
> to use the block-multiqueue.  For now pretend to have 4 issue queues
> as Jens pulled that out of his this hair and it worked.

Updated the blk-mq/drivers to carry this version.

-- 
Jens Axboe

