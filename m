Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965470AbaCUAEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:04:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965356AbaCUAE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.13 113/149] i2c: Remove usage of orphaned symbol OF_I2C
Date: Thu, 20 Mar 2014 17:04:36 -0700
Message-Id: <20140321000440.876284913@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 62c19c9d29e65086e5ae76df371ed2e6b23f00cd upstream.

The symbol is an orphan, don't depend on it anymore.

Signed-off-by: Richard Weinberger <richard@nod.at>
[wsa: enhanced commit message]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Fixes: 687b81d083c0 (i2c: move OF helpers into the core)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -387,7 +387,7 @@ config I2C_CBUS_GPIO
 
 config I2C_CPM
 	tristate "Freescale CPM1 or CPM2 (MPC8xx/826x)"
-	depends on (CPM1 || CPM2) && OF_I2C
+	depends on CPM1 || CPM2
 	help
 	  This supports the use of the I2C interface on Freescale
 	  processors with CPM1 or CPM2.


