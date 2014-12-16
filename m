Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaLPQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:25:28 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56872 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaLPQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:25:27 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH 1/8] drivers: watchdog: Fixed missing blank line warning
Date: Tue, 16 Dec 2014 21:55:22 +0530
Message-Id: <1418747129-3766-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a new line after declarations to remove the warning:
'Missing blank line after declarations'

Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
---
 drivers/watchdog/wdt_pci.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 48b2c05..b84a180 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -279,6 +279,7 @@ static int wdtpci_get_temperature(int *temperature)
 {
 	unsigned short c;
 	unsigned long flags;
+
 	spin_lock_irqsave(&wdtpci_lock, flags);
 	c = inb(WDT_RT);
 	udelay(8);
@@ -366,6 +367,7 @@ static ssize_t wdtpci_write(struct file *file, const char __user *buf,
 
 			for (i = 0; i != count; i++) {
 				char c;
+
 				if (get_user(c, buf + i))
 					return -EFAULT;
 				if (c == 'V')
-- 
1.7.9.5

