Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaIISf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:35:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42211 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaIISf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:35:26 -0400
Date: Tue, 9 Sep 2014 11:35:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/8] blk-mq: allocate flush_rq in blk_mq_init_flush()
Message-ID: <20140909183523.GA16750@infradead.org>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
 <1410267949-21904-2-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410267949-21904-2-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 09:05:42PM +0800, Ming Lei wrote:
> It is reasonable to allocate flush req in blk_mq_init_flush().
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
