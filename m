Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaDWLws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:52:48 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:13722 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaDWLwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:52:47 -0400
Message-ID: <5357A941.6080809@hisilicon.com>
Date: Wed, 23 Apr 2014 19:51:29 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <haojian.zhuang@linaro.org>, <xuwei5@hisilicon.com>
Subject: [PATCH 1/2] ARM: hip04: set ARCH_NR_GPIO to 128
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.65.131]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set ARCH_NR_GPIO for Hisilicon Soc hip04, which has 4 GPIO
controllers with 32 GPIOs each.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2961627..bb00e65 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1664,6 +1664,7 @@ config ARCH_NR_GPIO
 	default 352 if ARCH_VT8500
 	default 288 if ARCH_SUNXI
 	default 264 if MACH_H4700
+	default 128 if ARCH_HIP04
 	default 0
 	help
 	  Maximum number of GPIOs in the system.
-- 1.7.9.5

