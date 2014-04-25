Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaDYIMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:12:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43094 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaDYIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:12:03 -0400
Date: Fri, 25 Apr 2014 01:12:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] fix quoting of Ted's name in MAINTAINERS
Message-ID: <20140425081201.GA3120@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unpaired quotes really confuse mutt when copy & pasting it into the To:
form.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dc67b1..11a1966 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7293,7 +7293,7 @@ F:	Documentation/blockdev/ramdisk.txt
 F:	drivers/block/brd.c
 
 RANDOM NUMBER DRIVER
-M:	Theodore Ts'o" <tytso@mit.edu>
+M:	"Theodore Ts'o" <tytso@mit.edu>
 S:	Maintained
 F:	drivers/char/random.c
 
