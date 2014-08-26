Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaHZVSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:18:12 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38083 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754422AbaHZVSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:18:10 -0400
X-Sasl-enc: gYNUMFMCcqh0hIgVBX6UE8Lwa/1a0cGhYUxlH20qiRZC 1409087889
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] gcc: add compiler-gcc5.h to allow the kernel to be build with next gcc release
Date: Tue, 26 Aug 2014 23:18:02 +0200
Message-Id: <29799ddf4fbdde15a76bb3969c0b73f639d8ebf0.1409087832.git.hannes@stressinduktion.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 include/linux/compiler-gcc5.h | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 include/linux/compiler-gcc5.h

diff --git a/include/linux/compiler-gcc5.h b/include/linux/compiler-gcc5.h
new file mode 100644
index 0000000..4de95e7
--- /dev/null
+++ b/include/linux/compiler-gcc5.h
@@ -0,0 +1 @@
+#include <linux/compiler-gcc4.h>
-- 
1.9.3

