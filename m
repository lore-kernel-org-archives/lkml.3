Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaBKQft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:35:49 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50808 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaBKQfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:35:47 -0500
Date: Tue, 11 Feb 2014 08:35:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3]
 0001-blk-mq-don-t-assume-rq-errors-is-set-when-returning-.patch
 0002-blk-mq-pair-blk_mq_start_request-blk_mq_requeue_requ.patch series
Message-ID: <20140211163546.GA21083@infradead.org>
References: <20140211162712.055066190@bombadil.infradead.org>
 <20140211162739.912640751@bombadil.infradead.org>
 <20140211163104.GH19057@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211163104.GH19057@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 09:31:04AM -0700, Jens Axboe wrote:
> On Tue, Feb 11 2014, Christoph Hellwig wrote:
> > 
> 
> looks like the last one got botched?

That was quilt sending along the series file which I created by doing

ls > series

just ignore it, hopefully one day quilt and I will get along fine..

