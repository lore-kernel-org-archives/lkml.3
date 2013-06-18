Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386Ab3FRQ0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:26:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933230Ab3FRQRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:17:54 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Levi Pearson <levipearson@gmail.com>,
        Michael Scott <hashcode0f@gmail.com>, Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 22/48] wl12xx: fix minimum required firmware version for wl127x multirole
Date: Tue, 18 Jun 2013 09:17:48 -0700
Message-Id: <20130618161729.132773775@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luciano Coelho <coelho@ti.com>

commit 60c28cf18f970e1c1bd40d615596eeab6efbd9d7 upstream.

There was a typo in commit 8675f9 (wlcore/wl12xx/wl18xx: verify
multi-role and single-role fw versions), which was causing the
multirole firmware for wl127x (WiLink6) to be rejected.  The actual
minimum version needed for wl127x multirole is 6.5.7.0.42.

Reported-by: Levi Pearson <levipearson@gmail.com>
Reported-by: Michael Scott <hashcode0f@gmail.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ti/wl12xx/wl12xx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -41,7 +41,7 @@
 #define WL127X_IFTYPE_MR_VER	5
 #define WL127X_MAJOR_MR_VER	7
 #define WL127X_SUBTYPE_MR_VER	WLCORE_FW_VER_IGNORE
-#define WL127X_MINOR_MR_VER	115
+#define WL127X_MINOR_MR_VER	42
 
 /* FW chip version for wl128x */
 #define WL128X_CHIP_VER		7


