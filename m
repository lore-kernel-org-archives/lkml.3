Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaBGSXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:23:21 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35106 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBGSXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:23:19 -0500
Message-Id: <20140207182235.659185141@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 07 Feb 2014 10:22:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 0/4] minor blk-mq updates
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

these small blk-mq core updates fell out of the scsi multiqueue work.
