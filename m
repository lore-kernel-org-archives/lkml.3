Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbaCQN7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:59:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58304 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933361AbaCQN52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:57:28 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 12/15] ARM: at91: remove atmel_tsadcc platform_data
Date: Mon, 17 Mar 2014 14:57:05 +0100
Message-Id: <1395064628-644-13-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395064628-644-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395064628-644-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/board.h          | 3 ---
 include/linux/platform_data/atmel.h | 7 -------
 2 files changed, 10 deletions(-)

diff --git a/arch/arm/mach-at91/board.h b/arch/arm/mach-at91/board.h
index 6c08b341167d..4e773b55bc2d 100644
--- a/arch/arm/mach-at91/board.h
+++ b/arch/arm/mach-at91/board.h
@@ -118,9 +118,6 @@ struct isi_platform_data;
 extern void __init at91_add_device_isi(struct isi_platform_data *data,
 		bool use_pck_as_mck);
 
- /* Touchscreen Controller */
-extern void __init at91_add_device_tsadcc(struct at91_tsadcc_data *data);
-
 /* CAN */
 extern void __init at91_add_device_can(struct at91_can_data *data);
 
diff --git a/include/linux/platform_data/atmel.h b/include/linux/platform_data/atmel.h
index cea9f70133c5..4b452c6a2f7b 100644
--- a/include/linux/platform_data/atmel.h
+++ b/include/linux/platform_data/atmel.h
@@ -86,13 +86,6 @@ struct atmel_uart_data {
 	struct serial_rs485	rs485;		/* rs485 settings */
 };
 
- /* Touchscreen Controller */
-struct at91_tsadcc_data {
-	unsigned int    adc_clock;
-	u8		pendet_debounce;
-	u8		ts_sample_hold_time;
-};
-
 /* CAN */
 struct at91_can_data {
 	void (*transceiver_switch)(int on);
-- 
1.8.3.2

