Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaBERvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:51:09 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:54425 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678AbaBERvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:51:08 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag8TAIR58lJbsmUx/2dsb2JhbABZKIJkgkN7E7wGAgKBDxd0gmYcIxiBAjeICQHPGBeOdR2EIgSJR45jAZIhgzov
Date: Wed, 5 Feb 2014 17:52:22 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org
Subject: [PATCH 1/1] MAINTAINERS: Add ADFS
Message-Id: <20140205175222.28d6788471b6551831440ed0@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding generic fsdevel section for ADFS.
I guess status can be considered 'orphan' like affs and befs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2cf5cf..237d34e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -346,6 +346,12 @@ ADDRESS SPACE LAYOUT RANDOMIZATION (ASLR)
 M:	Jiri Kosina <jkosina@suse.cz>
 S:	Maintained
 
+ADFS FILE SYSTEM
+L:	linux-fsdevel@vger.kernel.org
+S:	Orphan
+F:	Documentation/filesystems/adfs.txt
+F:	fs/adfs/
+
 ADM1025 HARDWARE MONITOR DRIVER
 M:	Jean Delvare <jdelvare@suse.de>
 L:	lm-sensors@lm-sensors.org
-- 
1.8.1.4

