Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaA3Shf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:37:35 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39507 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaA3ShK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:37:10 -0500
From: Kumar Gala <galak@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kumar Gala <galak@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 4/4] tty: serial: msm: Enable building msm_serial for ARCH_QCOM
Date: Thu, 30 Jan 2014 12:36:42 -0600
Message-Id: <1391107002-21470-5-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1391107002-21470-1-git-send-email-galak@codeaurora.org>
References: <1391107002-21470-1-git-send-email-galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've split Qualcomm MSM support into legacy and multiplatform.  So add
the ability to build the serial driver on the newer ARCH_QCOM
multiplatform.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
Greg,

If we can get an ack on this, will probably go via the arm-soc tree to keep
the patchset together.

thanks

- k

 drivers/tty/serial/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index a3815ea..ce9b12d 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1024,7 +1024,7 @@ config SERIAL_SGI_IOC3
 
 config SERIAL_MSM
 	bool "MSM on-chip serial port support"
-	depends on ARCH_MSM
+	depends on ARCH_MSM || ARCH_QCOM
 	select SERIAL_CORE
 
 config SERIAL_MSM_CONSOLE
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

