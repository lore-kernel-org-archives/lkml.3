Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbaCQRhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:37:18 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:42424 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754709AbaCQRd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:33:29 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 05/22] Input: atmel_mxt_ts - select FW_LOADER for firmware code
Date: Mon, 17 Mar 2014 17:26:38 +0000
Message-Id: <1395077215-10922-6-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 961d58d..c2c0593 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -89,6 +89,7 @@ config TOUCHSCREEN_AD7879_SPI
 config TOUCHSCREEN_ATMEL_MXT
 	tristate "Atmel mXT I2C Touchscreen"
 	depends on I2C
+	select FW_LOADER
 	help
 	  Say Y here if you have Atmel mXT series I2C touchscreen,
 	  such as AT42QT602240/ATMXT224, connected to your system.
-- 
1.8.3.2

