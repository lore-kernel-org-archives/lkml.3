Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaBKQ1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:27:06 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaBKQ1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:27:04 -0500
Message-Id: <20140211162627.319192015@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 11 Feb 2014 08:26:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] blk-mq ->queue_rq error return fixes
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

