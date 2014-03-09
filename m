Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaCIWFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 18:05:01 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:50424 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201AbaCIWFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 18:05:00 -0400
Message-ID: <1394402698.9066.6.camel@x220>
Subject: [PATCH] MN10300: Fix typo "CONFIG_GEENERIC_CLOCKEVENTS_BROADCAST"
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Date: Sun, 09 Mar 2014 23:04:58 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2014 22:04:59.0582 (UTC) FILETIME=[9D1185E0:01CF3BE3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This typo has been in the tree since v2.6.37. Perhaps the negative test
for CONFIG_GENERIC_CLOCKEVENTS_BROADCAST can actually be dropped.
Anyhow, completely untested.

 arch/mn10300/kernel/cevt-mn10300.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mn10300/kernel/cevt-mn10300.c b/arch/mn10300/kernel/cevt-mn10300.c
index ccce35e..504ef6a 100644
--- a/arch/mn10300/kernel/cevt-mn10300.c
+++ b/arch/mn10300/kernel/cevt-mn10300.c
@@ -16,7 +16,7 @@
 #include "internal.h"
 
 #ifdef CONFIG_SMP
-#if (CONFIG_NR_CPUS > 2) && !defined(CONFIG_GEENERIC_CLOCKEVENTS_BROADCAST)
+#if (CONFIG_NR_CPUS > 2) && !defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)
 #error "This doesn't scale well! Need per-core local timers."
 #endif
 #else /* CONFIG_SMP */
-- 
1.8.5.3

