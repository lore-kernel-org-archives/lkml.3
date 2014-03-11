Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaCKOVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:21:53 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23848 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaCKOVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:21:52 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-ba-531f1bfdb0a0
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] mfd: max14577: Select REGMAP_IRQ
Date: Tue, 11 Mar 2014 15:21:42 +0100
Message-id: <1394547702-29775-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJMWRmVeSWpSXmKPExsVy+t/xy7p/peWDDd7vMrB4/cLQ4v7Xo4wW
	l3fNYbM43c3qwOJx59oeNo95JwM9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+PsiguMBc9Y
	Kpq/NzE2MH5m7mLk5JAQMJFY+2EXO4QtJnHh3nq2LkYuDiGBpYwS2898AEsICfQxSbR164LY
	bALGEpuXL2EDsUUEsiR+TFvNAmIzCxhK/Hz3B6xeGMhe1HCACcRmEVCVeLLgOpjNK+AuceTi
	N6BeDqBlChJzJtlMYORewMiwilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyPE6192MC4+ZnWI
	UYCDUYmHd4W/XLAQa2JZcWXuIUYJDmYlEd5kcflgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYx8
	ZUck9l1pe5lQV3Rt18kYExa/IyZ7zv2qjtNa9dBjujvHHA3bS8ul3KOWexVcy5fZIjMlbN48
	9rKlv3ayF/2zOpqmWLogxzTtXezvfv378p364mbZq8qX2f7bfqfDU0/y//ZZ2le1Frh8mGLH
	/P2+6KmfJbI7qlfqXM3SvOsgt+3grDsdeiFKLMUZiYZazEXFiQAvsvqp2AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAXIM 14577 MFD driver uses the regmap_irq_chip so it's Kconfig entry
should select REGMAP_IRQ.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 49bb445d846a..50dd5654d356 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -322,6 +322,7 @@ config MFD_MAX14577
 	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	select IRQ_DOMAIN
 	help
 	  Say yes here to support for Maxim Semiconductor MAX14577.
-- 
1.7.9.5

