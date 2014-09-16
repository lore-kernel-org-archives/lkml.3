Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaIPWqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:46:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36327 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaIPWqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:46:11 -0400
Date: Tue, 16 Sep 2014 15:46:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Robert Elliott <elliott@hp.com>, Ming Lei <ming.lei@canonical.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] blk-mq: avoid infite recursion with the FUA
Message-ID: <20140916224607.GA21051@infradead.org>
References: <1410903847-18519-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410903847-18519-1-git-send-email-hch@lst.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject is missing a " flag" at the end.  Feel free to fix it up on
commit :)
