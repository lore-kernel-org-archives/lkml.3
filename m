Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab3DXCa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:30:59 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:32871 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756843Ab3DXCa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:30:58 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V3 1/3] pwm: pxa: ARCH_MMP share same pwm driver with ARCH_PXA
Date: Tue, 23 Apr 2013 22:23:52 -0400
Message-ID: <1366770234-5829-2-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366770234-5829-1-git-send-email-chao.xie@marvell.com>
References: <1366770234-5829-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the pwm driver is not only used by ARCH_PXA but also ARCH_MMP

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/pwm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 115b644..9ec4040 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -108,7 +108,7 @@ config PWM_PUV3
 
 config PWM_PXA
 	tristate "PXA PWM support"
-	depends on ARCH_PXA
+	depends on ARCH_PXA || ARCH_MMP
 	help
 	  Generic PWM framework driver for PXA.
 
-- 
1.7.4.1

