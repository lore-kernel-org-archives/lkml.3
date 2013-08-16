Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3HPX4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 19:56:04 -0400
Received: from relay2.sgi.com ([192.48.179.30]:39680 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751503Ab3HPX4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 19:56:02 -0400
Date: Fri, 16 Aug 2013 18:01:42 -0500
From: Robin Holt <holt@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Robin Holt <robinmholt@gmail.com>,
        Cliff Whickman <cpw@sgi.com>
Subject: [PATCH] MAINTAINERS: Change ownership for SGI specific modules.
Message-ID: <20130816175041.GA10826@lnx-holt.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have taken a different job.  I am removing myself as maintainer of GRU.
Dimitri will continue to maintain the SGI GRU driver, changing the
XP/XPC/XPNET maintainer to Cliff Whickman, but leaving behind my personal
email address to answer any questions about the design or operation of
the XP family of drivers.

Signed-off-by: Robin Holt <holt@sgi.com>

---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7cacc88..2bcd7df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7366,7 +7366,6 @@ F:	drivers/net/ethernet/sfc/
 
 SGI GRU DRIVER
 M:	Dimitri Sivanich <sivanich@sgi.com>
-M:	Robin Holt <holt@sgi.com>
 S:	Maintained
 F:	drivers/misc/sgi-gru/
 
@@ -7386,7 +7385,8 @@ S:	Maintained for 2.6.
 F:	Documentation/sgi-visws.txt
 
 SGI XP/XPC/XPNET DRIVER
-M:	Robin Holt <holt@sgi.com>
+M:	Cliff Whickman <cpw@sgi.com>
+M:	Robin Holt <robinmholt@gmail.com>
 S:	Maintained
 F:	drivers/misc/sgi-xp/
 
-- 
1.8.2.1

