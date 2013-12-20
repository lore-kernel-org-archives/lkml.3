Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab3LTKmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:42:36 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36141 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756784Ab3LTKmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:42:33 -0500
From: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
To: andreas.frembs@studium.uni-erlangen.de
Cc: matthias.schoepe@studium.uni-erlangen.de, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel@i4.cs.fau.de
Subject: [PATCH 2/3] rtl8192e: Removing unused defines in rtl819x_Qos.h
Date: Fri, 20 Dec 2013 11:29:09 +0100
Message-Id: <1387535350-27442-3-git-send-email-andreas.frembs@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387535350-27442-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
References: <1387535350-27442-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rtl819x_Qos.h there were several macros defined but never used.
So we removed this macros.

Signed-off-by: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
Signed-off-by: Matthias Schoepe <matthias.schoepe@studium.uni-erlangen.de>

---
 drivers/staging/rtl8192e/rtl819x_Qos.h | 37 ----------------------------------
 1 file changed, 37 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl819x_Qos.h b/drivers/staging/rtl8192e/rtl819x_Qos.h
index 5ecd556..973342b 100644
--- a/drivers/staging/rtl8192e/rtl819x_Qos.h
+++ b/drivers/staging/rtl8192e/rtl819x_Qos.h
@@ -201,43 +201,6 @@ enum qos_ie_source {
 
 #define AC_PARAM_SIZE	4
 
-#define GET_WMM_AC_PARAM_AIFSN(_pStart) \
-	((u8)LE_BITS_TO_4BYTE(_pStart, 0, 4))
-#define SET_WMM_AC_PARAM_AIFSN(_pStart, _val) \
-	SET_BITS_TO_LE_4BYTE(_pStart, 0, 4, _val)
-
-#define GET_WMM_AC_PARAM_ACM(_pStart) \
-	((u8)LE_BITS_TO_4BYTE(_pStart, 4, 1))
-#define SET_WMM_AC_PARAM_ACM(_pStart, _val) \
-	SET_BITS_TO_LE_4BYTE(_pStart, 4, 1, _val)
-
-#define GET_WMM_AC_PARAM_ACI(_pStart) \
-	((u8)LE_BITS_TO_4BYTE(_pStart, 5, 2))
-#define SET_WMM_AC_PARAM_ACI(_pStart, _val) \
-	SET_BITS_TO_LE_4BYTE(_pStart, 5, 2, _val)
-
-#define GET_WMM_AC_PARAM_ACI_AIFSN(_pStart) \
-	((u8)LE_BITS_TO_4BYTE(_pStart, 0, 8))
-#define SET_WMM_AC_PARAM_ACI_AIFSN(_pStart, _val) \
-	SET_BITS_TO_LE_4BYTE(_pStart, 0, 8, _val)
-
-#define GET_WMM_AC_PARAM_ECWMIN(_pStart) \
-	((u8)LE_BITS_TO_4BYTE(_pStart, 8, 4))
-#define SET_WMM_AC_PARAM_ECWMIN(_pStart, _val) \
-	SET_BITS_TO_LE_4BYTE(_pStart, 8, 4, _val)
-
-#define GET_WMM_AC_PARAM_ECWMAX(_pStart) \
-	((u8)LE_BITS_TO_4BYTE(_pStart, 12, 4))
-#define SET_WMM_AC_PARAM_ECWMAX(_pStart, _val) \
-	SET_BITS_TO_LE_4BYTE(_pStart, 12, 4, _val)
-
-#define GET_WMM_AC_PARAM_TXOP_LIMIT(_pStart) \
-	((u8)LE_BITS_TO_4BYTE(_pStart, 16, 16))
-#define SET_WMM_AC_PARAM_TXOP_LIMIT(_pStart, _val) \
-	SET_BITS_TO_LE_4BYTE(_pStart, 16, 16, _val)
-
-
-
 #define WMM_PARAM_ELEMENT_SIZE	(8+(4*AC_PARAM_SIZE))
 
 enum qos_ele_subtype {
-- 
1.8.1.2

