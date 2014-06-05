Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaFESaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:30:46 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:27637 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751418AbaFESap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:30:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsENAPO2kFNXQDfT/2dsb2JhbABZgwesCQUBmCeBDxd0gwIjgRo3iEYB002FVYh9HYQqBI9OikWTOYM6Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/locking/rtmutex-tester.c: kernel-doc warning fix
Date: Thu,  5 Jun 2014 20:29:25 +0200
Message-Id: <1401992965-11256-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

attr was added by commit
4a0b2b4dbe1335
("sysdev: Pass the attribute to the low level sysdev show/store function")

and is unused here.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/locking/rtmutex-tester.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/locking/rtmutex-tester.c b/kernel/locking/rtmutex-tester.c
index 1d96dd0..abdc7d1 100644
--- a/kernel/locking/rtmutex-tester.c
+++ b/kernel/locking/rtmutex-tester.c
@@ -266,6 +266,7 @@ static int test_func(void *data)
 /**
  * sysfs_test_command - interface for test commands
  * @dev:	thread reference
+ * @attr:	unused
  * @buf:	command for actual step
  * @count:	length of buffer
  *
@@ -334,6 +335,7 @@ static ssize_t sysfs_test_command(struct device *dev, struct device_attribute *a
 /**
  * sysfs_test_status - sysfs interface for rt tester
  * @dev:	thread to query
+ * @attr:	unused
  * @buf:	char buffer to be filled with thread status info
  */
 static ssize_t sysfs_test_status(struct device *dev, struct device_attribute *attr,
-- 
1.8.4.5

