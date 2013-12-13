Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3LMWiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:38:09 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:50952 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3LMW1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:34 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Johan Mossberg <johan.mossberg@stericsson.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 055/115] gpu: ion: Export ion_client_create
Date: Fri, 13 Dec 2013 14:24:29 -0800
Message-Id: <1386973529-4884-56-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Mossberg <johan.mossberg@stericsson.com>

Will enable modules to allocate memory with ion.

Signed-off-by: Johan Mossberg <johan.mossberg@stericsson.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index c775e4f..7c25d9f 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -688,6 +688,7 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 
 	return client;
 }
+EXPORT_SYMBOL(ion_client_create);
 
 void ion_client_destroy(struct ion_client *client)
 {
-- 
1.8.3.2

