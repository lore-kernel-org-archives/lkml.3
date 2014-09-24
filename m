Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbaIXKW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:22:28 -0400
Received: from verein.lst.de ([213.95.11.211]:52778 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbaIXKW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:22:26 -0400
Date: Wed, 24 Sep 2014 12:22:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/10] blk-mq: handle failure path for initializing
	hctx
Message-ID: <20140924102225.GD19078@lst.de>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com> <1410786675-7761-10-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410786675-7761-10-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 09:11:13PM +0800, Ming Lei wrote:
> Failure of initializing one hctx isn't handled, so this patch
> introduces blk_mq_init_hctx() and its pair to handle it explicitly.
> Also this patch makes code cleaner.
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Shouldn't this go to Jens as a separate fix for 3.18?

