Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab3LQSrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:47:05 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:57997 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab3LQSrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:47:02 -0500
From: Laszlo Papp <lpapp@kde.org>
To: rob@landley.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laszlo Papp <lpapp@kde.org>
Subject: [PATCH] Documentation/driver-model/platform.txt: fix a typo
Date: Tue, 17 Dec 2013 18:42:24 +0000
Message-Id: <1387305744-15289-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sentence is not proper English, so the use of "general" is now replaced with
"in general". "generally" was also considered, but "in general" is probably the
correct in this case.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 Documentation/driver-model/platform.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/driver-model/platform.txt b/Documentation/driver-model/platform.txt
index 41f4163..07795ec 100644
--- a/Documentation/driver-model/platform.txt
+++ b/Documentation/driver-model/platform.txt
@@ -48,7 +48,7 @@ struct platform_driver {
 	struct device_driver driver;
 };
 
-Note that probe() should general verify that the specified device hardware
+Note that probe() should in general verify that the specified device hardware
 actually exists; sometimes platform setup code can't be sure.  The probing
 can use device resources, including clocks, and device platform_data.
 
-- 
1.8.5.1

