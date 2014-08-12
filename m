Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaHLX1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 19:27:01 -0400
Received: from jambon.ath.cx ([212.129.4.85]:39007 "EHLO debian"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751708AbaHLX1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 19:27:00 -0400
From: Junien Fridrick <linux.kernel@junien.fridrick.net>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH trivial] Documentation: ABI/testing: Spelling s/calss/class/
Date: Tue, 12 Aug 2014 23:26:57 +0000
Message-Id: <1407886017-2339-1-git-send-email-linux.kernel@junien.fridrick.net>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Junien Fridrick <linux.kernel@junien.fridrick.net>
---
 Documentation/ABI/testing/sysfs-class-net | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/ABI/testing/sysfs-class-net
index d322b05..e1b2e78 100644
--- a/Documentation/ABI/testing/sysfs-class-net
+++ b/Documentation/ABI/testing/sysfs-class-net
@@ -159,7 +159,7 @@ Description:
 		lower-level interface protocol used. Ethernet devices will show
 		a 'mtu' attribute value of 1500 unless changed.
 
-What:		/sys/calss/net/<iface>/netdev_group
+What:		/sys/class/net/<iface>/netdev_group
 Date:		January 2011
 KernelVersion:	2.6.39
 Contact:	netdev@vger.kernel.org
-- 
2.0.1

