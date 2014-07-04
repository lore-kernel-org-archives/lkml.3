Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaGDIul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:50:41 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:58439 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaGDIuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:50:39 -0400
Message-ID: <53B66A9F.6040404@hisilicon.com>
Date: Fri, 4 Jul 2014 16:49:35 +0800
From: xuwei <xuwei5@hisilicon.com>
Organization: hisilicon
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>, Haojian Zhuang <haojian.zhuang@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "Olof Johansson" <olof@lixom.net>, Kevin Hilman <khilman@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] MAINTAINERS:ARM:hisi: add Hisilicon SoC family
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.75.104]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.53B66AAA.0010,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 424472b81105c2b6fb549f6f0359ca85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new mach-hisi that will support Hisilicon SoCs based on ARMv7
and I am taking maintainership for it.

Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 134483f..a4f700a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -972,6 +972,14 @@ F:	arch/arm/mach-pxa/hx4700.c
 F:	arch/arm/mach-pxa/include/mach/hx4700.h
 F:	sound/soc/pxa/hx4700.c
 
+ARM/Hisilicon SoC support
+M:	Wei Xu <xuwei5@hisilicon.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+W:	www.hisilicon.com
+S:	Supported
+T:	git git://github.com/hisilicon/linux-hisi.git
+F:	arch/arm/mach-hisi/
+
 ARM/HP JORNADA 7XX MACHINE SUPPORT
 M:	Kristoffer Ericson <kristoffer.ericson@gmail.com>
 W:	www.jlime.com
-- 
1.8.1.2

