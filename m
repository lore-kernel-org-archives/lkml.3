Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaBJTtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:49:31 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:46974 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaBJTt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:49:28 -0500
Date: Mon, 10 Feb 2014 12:49:25 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] blk-mq: rework I/O completions
Message-ID: <20140210194923.GA3784@kernel.dk>
References: <20140210112437.858399303@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210112437.858399303@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10 2014, Christoph Hellwig wrote:
> This series reworks how the blk-mq core handles I/O completion.  The
> prime motivation was that the current code does not work when using
> a timeout handler that needs to complete requests after doing error
> handling.  A fallout from fixing that by making the completions more
> similar to the old request model is that we now can use the remote
> IPIs for driver-internal completions as well instead of just the final
> completion and thus get rid of duplicate code both in null_blk and
> the pending scsi work.

Thanks Christoph, applied all 3.

-- 
Jens Axboe

