Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663AbaCSQI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:08:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964941AbaCSQI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:08:26 -0400
Date: Wed, 19 Mar 2014 09:08:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] blk-mq: replace blk_mq_init_commands with a
 ->init_request method
Message-ID: <20140319160822.GA29017@infradead.org>
References: <20140317131827.793657833@bombadil.infradead.org>
 <20140317131941.297853893@bombadil.infradead.org>
 <CACVXFVMsFzyiR5gqyGk6jc0pRZP-3CZSvxr+oi36umVWJPjWZw@mail.gmail.com>
 <20140319075428.GA25529@infradead.org>
 <CACVXFVMgZUDjCLWOj-D3UfpmuX3hUHDLydc6FQY4qCzUyeupWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMgZUDjCLWOj-D3UfpmuX3hUHDLydc6FQY4qCzUyeupWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 04:48:47PM +0800, Ming Lei wrote:
> Actually it doesn't matter because flush_rq will be reinitialized
> before using, not like common request. And driver should only
> initialize req->special instead of the request itself, maybe it is
> better to document the fact.

I'll send a blurb to document this fact with the next round of updates.
