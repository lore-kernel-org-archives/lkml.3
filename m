Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaBKQ1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:27:41 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaBKQ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:27:40 -0500
Message-Id: <20140211162739.912640751@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 11 Feb 2014 08:27:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] 0001-blk-mq-don-t-assume-rq-errors-is-set-when-returning-.patch 0002-blk-mq-pair-blk_mq_start_request-blk_mq_requeue_requ.patch series
References: <20140211162712.055066190@bombadil.infradead.org>
Content-Disposition: inline; filename=series
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


