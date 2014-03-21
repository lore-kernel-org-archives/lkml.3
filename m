Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbaCUQwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:52:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:43871 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbaCUQwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:52:22 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: blk-mq updates, V2
Date: Fri, 21 Mar 2014 17:30:57 +0100
Message-Id: <1395419460-28229-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two fixes for partial completion support, and the addition of two methods
to allow drivers to easily init/cleanup per-request allocations.  The last
one has been rebased on your latest tree, and should also address the review
comments from Ming Lei.

