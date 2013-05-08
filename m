Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3EHTdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:33:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56079 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab3EHTdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:33:09 -0400
From: Borislav Petkov <bp@alien8.de>
To: cpufreq@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] cpufreq, ondemand: Remove leftover debug line
Date: Wed,  8 May 2013 21:34:48 +0200
Message-Id: <1368041688-29986-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

I don't see how the virtual address of the tuners pointer would be of
any help to anyone so remove it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/cpufreq/cpufreq_ondemand.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index b0ffef96bf77..4b9bb5def6f1 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -547,7 +547,6 @@ static int od_init(struct dbs_data *dbs_data)
 	tuners->io_is_busy = should_io_be_busy();
 
 	dbs_data->tuners = tuners;
-	pr_info("%s: tuners %p\n", __func__, tuners);
 	mutex_init(&dbs_data->mutex);
 	return 0;
 }
-- 
1.8.3.rc0

