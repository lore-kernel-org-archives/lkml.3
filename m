Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab3LMWeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:34:20 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:42817 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab3LMW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:56 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 069/115] gpu: ion: fix ion_platform_data definition
Date: Fri, 13 Dec 2013 14:24:43 -0800
Message-Id: <1386973529-4884-70-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

fix ion_platform_heap to make is use an usual way in board configuration file.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 679031c..226bfd5 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -103,7 +103,7 @@ struct ion_platform_heap {
  */
 struct ion_platform_data {
 	int nr;
-	struct ion_platform_heap heaps[];
+	struct ion_platform_heap *heaps;
 };
 
 /**
-- 
1.8.3.2

