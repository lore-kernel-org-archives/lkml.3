Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaDROV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:21:27 -0400
Received: from verein.lst.de ([213.95.11.211]:57085 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaDROVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:21:24 -0400
Date: Fri, 18 Apr 2014 16:21:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH next 1/4] blk-mq: free hctx->ctx_map when init failed
Message-ID: <20140418142122.GA31123@lst.de>
References: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com> <1397749778-14485-2-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397749778-14485-2-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:49:35PM +0800, Ming Lei wrote:
> Avoid memory leak in the failure path.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
