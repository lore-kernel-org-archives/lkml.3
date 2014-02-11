Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaBKQle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:41:34 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59420 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaBKQlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:41:32 -0500
Date: Tue, 11 Feb 2014 09:41:28 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3]
 0001-blk-mq-don-t-assume-rq-errors-is-set-when-returning-.patch
 0002-blk-mq-pair-blk_mq_start_request-blk_mq_requeue_requ.patch series
Message-ID: <20140211164128.GJ19057@kernel.dk>
References: <20140211162712.055066190@bombadil.infradead.org>
 <20140211162739.912640751@bombadil.infradead.org>
 <20140211163104.GH19057@kernel.dk>
 <20140211163546.GA21083@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211163546.GA21083@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11 2014, Christoph Hellwig wrote:
> On Tue, Feb 11, 2014 at 09:31:04AM -0700, Jens Axboe wrote:
> > On Tue, Feb 11 2014, Christoph Hellwig wrote:
> > > 
> > 
> > looks like the last one got botched?
> 
> That was quilt sending along the series file which I created by doing
> 
> ls > series
> 
> just ignore it, hopefully one day quilt and I will get along fine..

Ignored, applied the other two, thanks!

-- 
Jens Axboe

