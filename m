Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaHRKeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:34:00 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:63209 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaHRKcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:32:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: [PATCH 1/8] ARM: multi-v7: Enable ST BCH NAND
Date: Mon, 18 Aug 2014 11:31:52 +0100
Message-Id: <1408357919-19793-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408357919-19793-1-git-send-email-lee.jones@linaro.org>
References: <1408357919-19793-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-By: Pekon Gupta <pekon@pek-sem.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/configs/multi_v7_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 5348364..4670836 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -115,7 +115,9 @@ CONFIG_DMA_CMA=y
 CONFIG_CMA_SIZE_MBYTES=64
 CONFIG_OMAP_OCP2SCP=y
 CONFIG_MTD=y
+CONFIG_MTD_NAND=y
 CONFIG_MTD_M25P80=y
+CONFIG_MTD_NAND_STM_BCH=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_ICS932S401=y
 CONFIG_APDS9802ALS=y
-- 
1.9.1

