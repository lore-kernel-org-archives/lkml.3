Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3LNNDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:03:23 -0500
Received: from smtp27.mail.ru ([94.100.176.180]:49210 "EHLO smtp27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab3LNNDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:03:21 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/3] mfd: mc13xxx: Remove duplicate mc13xxx_get_flags() declaration
Date: Sat, 14 Dec 2013 17:03:11 +0400
Message-Id: <1387026192-21234-2-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387026192-21234-1-git-send-email-shc_work@mail.ru>
References: <1387026192-21234-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mc13xxx_get_flags() declaration given twice.
This patch removes this duplicate.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 include/linux/mfd/mc13xxx.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index f1b13b3..a326c85 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -21,8 +21,6 @@ int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val);
 int mc13xxx_reg_rmw(struct mc13xxx *mc13xxx, unsigned int offset,
 		u32 mask, u32 val);
 
-int mc13xxx_get_flags(struct mc13xxx *mc13xxx);
-
 int mc13xxx_irq_request(struct mc13xxx *mc13xxx, int irq,
 		irq_handler_t handler, const char *name, void *dev);
 int mc13xxx_irq_request_nounmask(struct mc13xxx *mc13xxx, int irq,
-- 
1.8.3.2

