Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaESONL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:13:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaESONK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:13:10 -0400
Date: Mon, 19 May 2014 07:13:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: time to move fs/bio.c to block/ ?
Message-ID: <20140519141309.GB21570@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently saw patches to fs/bio.c that were sent to Al instead of Jens.
I think having bio.c in fs/ is rather confusing, so maybe it's time to
include the simple git-mv for it in the your for-next tree?
