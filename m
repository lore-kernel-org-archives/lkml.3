Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaE0S5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:57:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:39261 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaE0S5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:57:39 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: blk-mq: refactor request allocation
Date: Tue, 27 May 2014 20:59:45 +0200
Message-Id: <1401217190-32453-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series streamlines the request allocation path.

