Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3HXAbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 20:31:40 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:30035 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab3HXAbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 20:31:39 -0400
From: Libin <huawei.libin@huawei.com>
To: Rob Landley <rob@landley.net>, Vegard Nossum <vegardno@ifi.uio.no>,
        Pekka Enberg <penberg@kernel.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangyijing@huawei.com>, <guohanjun@huawei.com>
Subject: [PATCH] Documentation/kmemcheck: update kmemcheck documentation
Date: Sat, 24 Aug 2013 08:31:01 +0800
Message-ID: <1377304261-24668-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kmemcheck configuration menu location correction in Documentation/
kmemcheck.txt

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 Documentation/kmemcheck.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/kmemcheck.txt b/Documentation/kmemcheck.txt
index c28f828..9398a50 100644
--- a/Documentation/kmemcheck.txt
+++ b/Documentation/kmemcheck.txt
@@ -91,9 +91,9 @@ information from the kmemcheck warnings, which is extremely valuable in
 debugging a problem. This option is not mandatory, however, because it slows
 down the compilation process and produces a much bigger kernel image.
 
-Now the kmemcheck menu should be visible (under "Kernel hacking" / "kmemcheck:
-trap use of uninitialized memory"). Here follows a description of the
-kmemcheck configuration variables:
+Now the kmemcheck menu should be visible (under "Kernel hacking" / "Memory
+Debugging" / "kmemcheck: trap use of uninitialized memory"). Here follows
+a description of the kmemcheck configuration variables:
 
   o CONFIG_KMEMCHECK
 
-- 
1.8.2.1


