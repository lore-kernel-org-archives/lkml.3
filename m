Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaBLXma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 18:42:30 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:37220 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaBLXm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 18:42:29 -0500
X-IronPort-AV: E=Sophos;i="4.95,835,1384329600"; 
   d="scan'208";a="14578771"
From: Markus Mayer <markus.mayer@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Linux GPIO List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?q?=5BPATCH=5D=20MAINTAINERS=3A=20Add=20Broadcom=20GPIO=20maintainer?=
Date: Wed, 12 Feb 2014 15:42:27 -0800
Message-ID: <1392248547-11627-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

List myself as maintainer for Broadcom's Kona GPIO driver.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---

Does that look like a reasonable way to make this change? I added the
entry alphabetically in the BROADCOM section.

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2cf5cf..896cf2b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1909,6 +1909,13 @@ L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/bnx2i/
 
+BROADCOM KONA GPIO DRIVER
+M:	Markus Mayer <markus.mayer@linaro.org>
+L:	bcm-kernel-feedback-list@broadcom.com
+S:	Supported
+F:	drivers/gpio/gpio-bcm-kona.c
+F:	Documentation/devicetree/bindings/gpio/gpio-bcm-kona.txt
+
 BROADCOM SPECIFIC AMBA DRIVER (BCMA)
 M:	Rafał Miłecki <zajec5@gmail.com>
 L:	linux-wireless@vger.kernel.org
-- 
1.7.9.5

