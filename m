Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaEZQHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:07:36 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33284 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:07:31 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 16/24] staging: rtl8188eu: Remove unused function declaration.
Date: Mon, 26 May 2014 21:35:31 +0530
Message-Id: <1401120339-23667-16-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/odm_interface.h |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/odm_interface.h b/drivers/staging/rtl8188eu/include/odm_interface.h
index 5338290..ba58a67 100644
--- a/drivers/staging/rtl8188eu/include/odm_interface.h
+++ b/drivers/staging/rtl8188eu/include/odm_interface.h
@@ -58,10 +58,6 @@ enum odm_h2c_cmd {
 	ODM_MAX_H2CCMD
 };
 
-/*  ODM Timer relative API. */
-
-void ODM_CancelTimer(struct odm_dm_struct *pDM_Odm, struct timer_list *pTimer);
-
 /*  ODM FW relative API. */
 u32 ODM_FillH2CCmd(u8 *pH2CBuffer, u32 H2CBufferLen, u32 CmdNum,
 		   u32 *pElementID, u32 *pCmdLen, u8 **pCmbBuffer,
-- 
1.7.10.4

