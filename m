Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaDUVrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:47:22 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62231 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaDUVrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:47:19 -0400
From: srinivas.kandagatla@linaro.org
To: linux-mmc@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org,
        agross@quicinc.com, linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH RFC 01/12] ARM: amba: Add Qualcomm vendor ID.
Date: Mon, 21 Apr 2014 22:47:11 +0100
Message-Id: <1398116831-31235-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds Qualcomm amba vendor Id to the list. This ID is used in mmci
driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 include/linux/amba/bus.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 63b5eff..fdd7e1b 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -47,6 +47,7 @@ struct amba_driver {
 enum amba_vendor {
 	AMBA_VENDOR_ARM = 0x41,
 	AMBA_VENDOR_ST = 0x80,
+	AMBA_VENDOR_QCOM = 0x51,
 };
 
 extern struct bus_type amba_bustype;
-- 
1.7.9.5

