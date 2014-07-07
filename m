Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaGGDSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:18:45 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:39625 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaGGDSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:18:44 -0400
Message-ID: <53BA114E.4040700@hisilicon.com>
Date: Mon, 7 Jul 2014 11:17:34 +0800
From: xuwei <xuwei5@hisilicon.com>
Organization: hisilicon
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Li Zefan <lizefan@huawei.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "Olof Johansson" <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] MAINTAINERS:ARM:hisi: add Hisilicon SoC family
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.75.104]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new mach-hisi that will support Hisilicon SoCs based on ARMv7 and
I am taking maintainership for it.

Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 134483f..d4ac517 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -972,6 +972,14 @@ F:	arch/arm/mach-pxa/hx4700.c
 F:	arch/arm/mach-pxa/include/mach/hx4700.h
 F:	sound/soc/pxa/hx4700.c
 
+ARM/HISILICON SOC SUPPORT
+M:	Wei Xu <xuwei5@hisilicon.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+W:	http://www.hisilicon.com
+S:	Supported
+T:	git git://github.com/hisilicon/linux-hisi.git
+F:	arch/arm/mach-hisi/
+
 ARM/HP JORNADA 7XX MACHINE SUPPORT
 M:	Kristoffer Ericson <kristoffer.ericson@gmail.com>
 W:	www.jlime.com
-- 
1.8.1.2

