Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaGVLQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:16:21 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:40922 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaGVLLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:11:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/19] mfd: tps80031: Fix 'missing break or fall-through comment' warning
Date: Tue, 22 Jul 2014 12:11:09 +0100
Message-Id: <1406027485-15657-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
+       case TPS80031_BACKUP_REG:

total: 0 errors, 1 warnings, 573 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/tps80031.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/tps80031.c b/drivers/mfd/tps80031.c
index ed6c5b0..7a3806c 100644
--- a/drivers/mfd/tps80031.c
+++ b/drivers/mfd/tps80031.c
@@ -334,6 +334,7 @@ static bool rd_wr_reg_id1(struct device *dev, unsigned int reg)
 	case TPS80031_PREQ1_RES_ASS_A ... TPS80031_PREQ3_RES_ASS_C:
 	case TPS80031_SMPS_OFFSET ... TPS80031_BATDEBOUNCING:
 	case TPS80031_CFG_INPUT_PUPD1 ... TPS80031_CFG_SMPS_PD:
+		/* Fall through */
 	case TPS80031_BACKUP_REG:
 		return true;
 	default:
-- 
1.8.3.2

