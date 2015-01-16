Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbbAPMFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:05:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:44162 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbbAPMFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:05:53 -0500
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Dongsu Park <dongsu.park@profitbricks.com>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org
Subject: cleanup and refactor BLOCK_PC mapping helpers
Date: Fri, 16 Jan 2015 13:04:48 +0100
Message-Id: <1421409895-21377-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is based on the first two patches from the reent
series that Dongsu Park recently sent, and refactors and cleanups
up various aspect of our BLOCK_PC mapping helpers.

