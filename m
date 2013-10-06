Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3JFPYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 11:24:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60738 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3JFPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 11:24:11 -0400
Message-Id: <20131006152237.612666544@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Sun, 06 Oct 2013 08:22:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] blk-mq updates
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 makes sure bios are completed more carefully, fixing the regression
with the earlier patch from Mike as well as a few issues found during code
inspection.  Patches 2 and 3 are a split up and better documented version
of "blk-mq: blk-mq should free bios in pass through case", and the last two
are minor cleanups.
