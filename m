Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab3LVTVf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 14:21:35 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:33890 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab3LVTVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 14:21:34 -0500
Date: Sun, 22 Dec 2013 11:21:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: status of block-integrity
Message-ID: <20131222192128.GA28532@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have the block integrity code to support DIF/DIX in the the tree for
about 5 and a half years, and we still don't have a single consumer of
it.  By normal kernel rules it should never have been merged, or at
least the bitrot long removed.

Given that we'll have a lot of work to do in this area with block
multiqueue I think it's time to either kill it off for good or make sure
we can actually use and test it.
