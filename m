Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbaHTG0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:26:25 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:48532 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaHTG0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:26:24 -0400
From: <harish_kandiga@mentor.com>
To: <rdunlap@infradead.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] lockup-watchdogs: Fix a typo
Date: Wed, 20 Aug 2014 11:56:17 +0530
Message-ID: <1408515977-13263-1-git-send-email-harish_kandiga@mentor.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 20 Aug 2014 06:26:20.0660 (UTC) FILETIME=[A81F0340:01CFBC3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harish Jenny K N <harish_kandiga@mentor.com>

s/BOOTPARAM_HARDLOCKUP_PANIC/BOOTPARAM_SOFTLOCKUP_PANIC

Signed-off-by: Harish Jenny K N <harish_kandiga@mentor.com>
---
 Documentation/lockup-watchdogs.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/lockup-watchdogs.txt b/Documentation/lockup-watchdogs.txt
index d2a3660..ab0baa6 100644
--- a/Documentation/lockup-watchdogs.txt
+++ b/Documentation/lockup-watchdogs.txt
@@ -12,7 +12,7 @@ stack trace is displayed upon detection and, by default, the system
 will stay locked up. Alternatively, the kernel can be configured to
 panic; a sysctl, "kernel.softlockup_panic", a kernel parameter,
 "softlockup_panic" (see "Documentation/kernel-parameters.txt" for
-details), and a compile option, "BOOTPARAM_HARDLOCKUP_PANIC", are
+details), and a compile option, "BOOTPARAM_SOFTLOCKUP_PANIC", are
 provided for this.
 
 A 'hardlockup' is defined as a bug that causes the CPU to loop in
-- 
1.7.9.5

