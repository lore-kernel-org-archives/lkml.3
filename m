Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaFFQQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:16:43 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:51294 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaFFQQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:16:40 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/13] staging: rtl8188eu: HalPhyRf_8188e.c: Remove unused macro
Date: Fri,  6 Jun 2014 21:45:18 +0530
Message-Id: <1402071320-14400-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
References: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index fafb18c..5afaad2 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -489,7 +489,6 @@ odm_TXPowerTrackingCallback_ThermalMeter_8188E(
 
 /* 1 7.	IQK */
 #define MAX_TOLERANCE		5
-#define IQK_DELAY_TIME		1		/* ms */
 
 static u8 /* bit0 = 1 => Tx OK, bit1 = 1 => Rx OK */
 phy_PathA_IQK_8188E(struct adapter *adapt, bool configPathB)
-- 
1.7.10.4

