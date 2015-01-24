Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbbAXPGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 10:06:19 -0500
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:23293 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbbAXPF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 10:05:57 -0500
X-ME-Helo: beldin.home
X-ME-Date: Sat, 24 Jan 2015 16:05:55 +0100
X-ME-IP: 109.222.126.211
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH v4 4/4] MAINTAINERS: add entry for lubbock-cplds
Date: Sat, 24 Jan 2015 16:05:03 +0100
Message-Id: <1422111903-22176-4-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422111903-22176-1-git-send-email-robert.jarzmik@free.fr>
References: <1422111903-22176-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add entry Lubbock cplds driver into the pxa platform scope.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ddb9ac8..8c6a49d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7681,6 +7681,7 @@ T:	git git://github.com/hzhuang1/linux.git
 T:	git git://github.com/rjarzmik/linux.git
 S:	Maintained
 F:	arch/arm/mach-pxa/
+F:	drivers/mfd/lubbock.c
 F:	drivers/pcmcia/pxa2xx*
 F:	drivers/spi/spi-pxa2xx*
 F:	drivers/usb/gadget/udc/pxa2*
-- 
2.1.0

