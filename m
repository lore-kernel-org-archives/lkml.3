Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaGTKVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 06:21:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:50461 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaGTKVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 06:21:12 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: support > 16 byte CDBs for blocklayer SG_IO
Date: Sun, 20 Jul 2014 12:23:22 +0200
Message-Id: <1405851804-29096-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the bsg and sg drivers to support large CDBs by allocation
the larger than 16 byte CDB array if nessecary.

