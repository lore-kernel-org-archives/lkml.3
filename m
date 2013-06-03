Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3FCCXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:23:18 -0400
Received: from mail1.windriver.com ([147.11.146.13]:48653 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3FCCXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:23:07 -0400
From: Ying Xue <ying.xue@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <richardcochran@gmail.com>, <prarit@redhat.com>
Subject: [PATCH] ntp: Eliminate compile warning of unused variable flags
Date: Mon, 3 Jun 2013 10:22:52 +0800
Message-ID: <1370226172-17850-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/time/ntp.c: In function ‘__hardpps’:
kernel/time/ntp.c:877:16: warning: unused variable ‘flags’ [-Wunused-variable]

Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 kernel/time/ntp.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 12ff13a..8f5b3b9 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -874,7 +874,6 @@ static void hardpps_update_phase(long error)
 void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 {
 	struct pps_normtime pts_norm, freq_norm;
-	unsigned long flags;
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
-- 
1.7.9.5

