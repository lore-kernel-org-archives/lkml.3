Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab3AQDEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:04:41 -0500
Received: from smtp.outflux.net ([198.145.64.163]:42358 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758814Ab3AQCys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:48 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Kalle Valo <kvalo@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 12/86] drivers/net/wireless/ath/ath6kl: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:04 -0800
Message-Id: <1358391258-1771-13-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ath/ath6kl/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index 26c4b72..630c83d 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -18,7 +18,6 @@ config ATH6KL_USB
 	depends on ATH6KL
 	depends on USB
 	depends on CFG80211
-	depends on EXPERIMENTAL
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros AR6004 chipset running over USB. This is still under
-- 
1.7.9.5

