Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaEZQIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:08:11 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59441 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:08:08 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 22/24] staging: rtl8188eu: Remove unused function declaration.
Date: Mon, 26 May 2014 21:35:37 +0530
Message-Id: <1401120339-23667-22-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/odm_interface.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/odm_interface.h b/drivers/staging/rtl8188eu/include/odm_interface.h
index 2c2991e..e29ac79 100644
--- a/drivers/staging/rtl8188eu/include/odm_interface.h
+++ b/drivers/staging/rtl8188eu/include/odm_interface.h
@@ -27,10 +27,4 @@ enum odm_h2c_cmd {
 	ODM_H2C_PathDiv = 2,
 	ODM_MAX_H2CCMD
 };
-
-/*  ODM FW relative API. */
-u32 ODM_FillH2CCmd(u8 *pH2CBuffer, u32 H2CBufferLen, u32 CmdNum,
-		   u32 *pElementID, u32 *pCmdLen, u8 **pCmbBuffer,
-		   u8 *CmdStartSeq);
-
 #endif	/*  __ODM_INTERFACE_H__ */
-- 
1.7.10.4

