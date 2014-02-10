Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaBJTuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:50:39 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48339 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbaBJTuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:50:09 -0500
Date: Mon, 10 Feb 2014 12:50:04 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: virtio_blk softlockup in block/for-linus
Message-ID: <20140210195003.GB3784@kernel.dk>
References: <20140210112420.GA17598@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210112420.GA17598@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10 2014, Christoph Hellwig wrote:
> When running xfstests on Jens' current for-linus tree I see the
> softlockup below (which locks the VM hard).  I bisected it down to 
> "blk-mq: Don't reserve a tag for flush request".  My recently posted
> flush rework also fixes the issue, btw.

I've applied the flush re-work.

-- 
Jens Axboe

