Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaBINHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:07:15 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:53695 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbaBINHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:07:13 -0500
Message-ID: <1391951231.20670.4.camel@x220>
Subject: [PATCH] [TRIVIAL] net-sysfs: fix comment typo 'CONFIG_SYFS'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 14:07:11 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 13:07:11.0732 (UTC) FILETIME=[D85D5B40:01CF2597]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 net/core/net-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 9388624..549043c 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -789,7 +789,7 @@ exit:
 	kobject_put(kobj);
 	return error;
 }
-#endif /* CONFIG_SYFS */
+#endif /* CONFIG_SYSFS */
 
 int
 net_rx_queue_update_kobjects(struct net_device *net, int old_num, int new_num)
-- 
1.8.5.3

