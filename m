Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaBTXdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:33:54 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58367 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaBTXdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:33:52 -0500
Message-Id: <20140220233235.443299098@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 20 Feb 2014 15:32:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 0/3] next round of blk-mq updates
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple more blkmq updates: a trivial cleanup, a consolidation of two very
similar functions into one, and support for partial request completions,
a feature needed by the work in progress scsi blk-mq support.
