Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaLHNdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:33:00 -0500
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:57948 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbaLHNc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:32:59 -0500
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, santosh.shilimkar@ti.com,
        Pramod Gurav <pramod.gurav@smartplayin.com>
Subject: [PATCH] drivers: Kconfig: Remove duplicate sourcing of soc folder
Date: Mon,  8 Dec 2014 19:06:24 +0530
Message-Id: <1418045784-4602-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folder soc/ was sourced twice somehow. Remove duplicate entry.

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/Kconfig |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 1a693d3..5add358 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -132,8 +132,6 @@ source "drivers/staging/Kconfig"
 
 source "drivers/platform/Kconfig"
 
-source "drivers/soc/Kconfig"
-
 source "drivers/clk/Kconfig"
 
 source "drivers/hwspinlock/Kconfig"
-- 
1.7.9.5

