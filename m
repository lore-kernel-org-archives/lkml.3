Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaHLMDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:03:46 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:55681 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaHLMDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:03:43 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
X-Google-Original-From: Srinivas Kandagatla <srinivas.kandadgatla@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH RFC 1/5] mmc: mmci: Enable SDIO support for Qualcomm variant data
Date: Tue, 12 Aug 2014 13:03:33 +0100
Message-Id: <1407845013-8228-1-git-send-email-srinivas.kandadgatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
References: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch sets sdio flag in qualcomm variant data to enable WLAN
connected via sdio on IFC6410 board.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 9059570..8641572 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -203,6 +203,7 @@ static struct variant_data variant_qcom = {
 	.datactrl_mask_ddrmode	= MCI_QCOM_CLK_SELECT_IN_DDR_MODE,
 	.data_cmd_enable	= MCI_QCOM_CSPM_DATCMD,
 	.blksz_datactrl4	= true,
+	.sdio			= true,
 	.datalength_bits	= 24,
 	.pwrreg_powerup		= MCI_PWR_UP,
 	.f_max			= 208000000,
-- 
1.9.1

