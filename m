Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbaAHRj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:39:56 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49345 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbaAHRjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:39:54 -0500
From: Laszlo Papp <lpapp@kde.org>
To: lee.jones@linaro.org
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        Laszlo Papp <lpapp@kde.org>
Subject: [PATCH] drivers/mfd/stw481x.c: fix a typo
Date: Wed,  8 Jan 2014 17:34:50 +0000
Message-Id: <1389202490-31506-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sentence is not proper English due to a minor typo of "addess". The 'r'
letter is missing which this change is now amending. This was caught while
reading the driver source for getting more information about it, and then I ran
the vim spellchecker to make sure there are no more typos in this file.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 drivers/mfd/stw481x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/stw481x.c b/drivers/mfd/stw481x.c
index 1243d5c..24b8a12 100644
--- a/drivers/mfd/stw481x.c
+++ b/drivers/mfd/stw481x.c
@@ -36,7 +36,7 @@
  * @reg: power control register to fetch
  *
  * The power control registers is a set of one-time-programmable registers
- * in its own register space, accessed by writing addess bits to these
+ * in its own register space, accessed by writing address bits to these
  * two registers: bits 7,6,5 of PCTL_REG_LO corresponds to the 3 LSBs of
  * the address and bits 8,9 of PCTL_REG_HI corresponds to the 2 MSBs of
  * the address, forming an address space of 5 bits, i.e. 32 registers
-- 
1.8.5.1

