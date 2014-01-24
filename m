Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaAXNWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:22:37 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:57357 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaAXNWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:22:36 -0500
Date: Fri, 24 Jan 2014 05:22:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: ipi_redirect vs rq_affinity
Message-ID: <20140124132234.GA8553@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

it seems like blk-mq uses the ipi_redirect attribute in pretty much the
same way as the old blk-softirq code used the rq_affinity one, except
that the old code has an additional option to direct into any core in
the current package.

Is there any good reason to not reuse the old name and semantics?
