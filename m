Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaFBKLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:11:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaFBKLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:11:43 -0400
Date: Mon, 2 Jun 2014 03:11:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matias Bj??rling <m@bjorling.me>
Cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v4] basic conversion to blk-mq
Message-ID: <20140602101140.GA16892@infradead.org>
References: <1401400285-25003-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401400285-25003-1-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There also should be patch to switch nvme to the block layer SG_IO
implementation and BLOCK_PC requests instead of it's own implemenation.

Not that I see any point at all in having all that cruft in nvme-scsi
to start with..
