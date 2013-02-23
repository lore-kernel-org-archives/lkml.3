Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab3BWHlE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 02:41:04 -0500
Received: from smtp.outflux.net ([198.145.64.163]:55292 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab3BWHlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 02:41:01 -0500
Date: Fri, 22 Feb 2013 23:40:01 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] md/raid456: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130223074001.GA5199@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 7cdf359..0cc3a3d 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -158,7 +158,6 @@ config MULTICORE_RAID456
 	bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
 	depends on MD_RAID456
 	depends on SMP
-	depends on EXPERIMENTAL
 	---help---
 	  Enable the raid456 module to dispatch per-stripe raid operations to a
 	  thread pool.
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
