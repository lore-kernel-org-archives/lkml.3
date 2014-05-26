Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaEZQHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:07:23 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54828 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:07:19 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 14/24] staging: rtl8188eu: Remove unused macros in odm_interface.h
Date: Mon, 26 May 2014 21:35:29 +0530
Message-Id: <1401120339-23667-14-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/odm_interface.h |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/odm_interface.h b/drivers/staging/rtl8188eu/include/odm_interface.h
index 548a309..3fc3e3c 100644
--- a/drivers/staging/rtl8188eu/include/odm_interface.h
+++ b/drivers/staging/rtl8188eu/include/odm_interface.h
@@ -21,18 +21,7 @@
 #ifndef	__ODM_INTERFACE_H__
 #define __ODM_INTERFACE_H__
 
-/*  */
-/*  =========== Constant/Structure/Enum/... Define */
-/*  */
-
-/*  */
 /*  =========== Macro Define */
-/*  */
-
-#define _reg_all(_name)			ODM_##_name
-#define _reg_ic(_name, _ic)		ODM_##_name##_ic
-#define _bit_all(_name)			BIT_##_name
-#define _bit_ic(_name, _ic)		BIT_##_name##_ic
 
 /*  _cat: implemented by Token-Pasting Operator. */
 
-- 
1.7.10.4

