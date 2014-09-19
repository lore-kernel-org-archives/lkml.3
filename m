Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbaISRy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:54:57 -0400
Received: from verein.lst.de ([213.95.11.211]:44341 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbaISRy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:54:56 -0400
Date: Fri, 19 Sep 2014 19:54:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: auto-start hw queue in requeue
Message-ID: <20140919175452.GA20333@lst.de>
References: <1411136570-23439-1-git-send-email-ming.lei@canonical.com> <20140919174806.GA19983@lst.de> <541C6D7B.5000005@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541C6D7B.5000005@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 11:52:59AM -0600, Jens Axboe wrote:
> I agree. I think Ming wanted to avoid an unnecessary bitflip if
> possible, but the fix is more convoluted than I would like.

If the requeue from irq context ever ends up in the fast path we
have much worse problems..

