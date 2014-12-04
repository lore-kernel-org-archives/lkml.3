Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaLDKWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:22:16 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:55346 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaLDKWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:22:12 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, Nunzio Raciti <nunzio.raciti@st.com>
Subject: [PATCH v2 RESEND 04/11] mtd: st_spi_fsm: Add support for Micron N25Q512A
Date: Thu,  4 Dec 2014 10:21:45 +0000
Message-Id: <1417688512-7644-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417688512-7644-1-git-send-email-lee.jones@linaro.org>
References: <1417688512-7644-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nunzio Raciti <nunzio.raciti@st.com>

This patch adds support for the Micron N25Q512A device as required
by the B2147 (STiD127) board.

Signed-off-by: Nunzio Raciti <nunzio.raciti@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 35eb475..1e79e9b 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -374,6 +374,8 @@ static struct flash_info flash_types[] = {
 	  stfsm_n25q_config },
 	{ "n25q256", 0x20ba19, 0, 64 * 1024,  512,
 	  N25Q_FLAG | FLASH_FLAG_32BIT_ADDR, 108, stfsm_n25q_config },
+	{ "n25q512", 0x20ba20, 0, 64 * 1024,  1024,
+	  N25Q_FLAG | FLASH_FLAG_32BIT_ADDR, 108, stfsm_n25q_config},
 
 	/*
 	 * Spansion S25FLxxxP
-- 
1.9.1

