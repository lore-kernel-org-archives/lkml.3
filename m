Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3LND2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:28:06 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:53068 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3LND1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:19 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 114/115] ion: Improve ION config description
Date: Fri, 13 Dec 2013 19:26:34 -0800
Message-Id: <1386991595-6251-22-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly just to quiet checkpatch warnings, be more verbose
in describing the ION config option.

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/Kconfig | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
index 3215bd8..a342d96 100644
--- a/drivers/staging/android/ion/Kconfig
+++ b/drivers/staging/android/ion/Kconfig
@@ -2,8 +2,12 @@ menuconfig ION
 	tristate "Ion Memory Manager"
 	select GENERIC_ALLOCATOR
 	select DMA_SHARED_BUFFER
-	help
-	  Chose this option to enable the ION Memory Manager.
+	---help---
+	  Chose this option to enable the ION Memory Manager,
+	  used by Android to efficiently allocate buffers
+	  from userspace that can be shared between drivers.
+	  If you're not using Android its probably safe to
+	  say N here.
 
 config ION_TEST
 	tristate "Ion Test Device"
-- 
1.8.3.2

