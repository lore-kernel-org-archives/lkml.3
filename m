Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3LNUHC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:07:02 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50113 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab3LNUG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:06:59 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 2/2] ion: Reenable the build
Date: Sat, 14 Dec 2013 12:06:46 -0800
Message-Id: <1387051606-10440-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387051606-10440-1-git-send-email-john.stultz@linaro.org>
References: <20131214170618.GA17461@kroah.com>
 <1387051606-10440-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ION builds, reenable it in the build.

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
index 29c5ff0..0a01e191 100644
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@ -1,7 +1,6 @@
 ccflags-y += -I$(src)			# needed for trace events
 
-# ION doesn't build just yet, so disable it from the build
-#obj-y					+= ion/
+obj-y					+= ion/
 
 obj-$(CONFIG_ANDROID_BINDER_IPC)	+= binder.o
 obj-$(CONFIG_ASHMEM)			+= ashmem.o
-- 
1.8.3.2

