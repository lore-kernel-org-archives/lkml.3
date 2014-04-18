Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaDRNV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:21:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17043 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbaDRNTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:19:09 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-48-5351264a23e6
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/6] rtc: s5m: Add support for S2MPS14
Date: Fri, 18 Apr 2014 15:18:53 +0200
Message-id: <1397827139-14589-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7peaoHBBs//aVksuXiV3WLjjPWs
	Fq9fGFqcbXrDbnH/61FGi8u75rBZzDi/j8li7ZG77Bb7OzsYLU53s1pcXPGFyYHbY8/Ek2we
	d67tYfOYdzLQo2/LKkaP6fN+Mnl83iQXwBbFZZOSmpNZllqkb5fAlfF20Qzmgq0cFVt2/WRp
	YDzP1sXIySEhYCLxblsTO4QtJnHh3nqgOBeHkMBSRolXl+dBOX1MEm++NYJ1sAkYS2xevgQs
	ISLwi1Hi27JFLCAOs8BRRonpvW+ZQKqEBSwl9p/cDmazCKhKfO3fxAhi8wq4SyyacocRYp+C
	xLIva5knMHIvYGRYxSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESVl93MC49ZnWIUYCDUYmH
	98JX/2Ah1sSy4srcQ4wSHMxKIry7/wYEC/GmJFZWpRblxxeV5qQWH2Jk4uCUamDUmrBLTfii
	8L+nTr7LGRpl9XxZ5S4I17vtEym5+WNh73+n+yuLSviTBZcJn5jKxjjlRKTyhWLfdw3HxWzf
	b1t22snjqO1zHuUq8T9FT3Q+6xobMu+I3L6q59xl6fzry/U8jvuWu007F+E4d0lkM8+bTW4K
	CVduzN6XNidth9mbeF/PjU4rT3UqsRRnJBpqMRcVJwIAFJCK3AkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is second version of patches for S5M RTC driver adding support
for S2MPS14 device.

The patchset is rebased against current Linus' tree (v3.15-rc1-136-gd3e74dc8280c)
and on my last patch for RTC regmap fixes:
 - mfd/rtc: s5m: Do not allocate RTC I2C dummy and regmap for unsupported chipsets
   https://lkml.org/lkml/2014/4/14/50

Changes since v1
================
1. Add patch 6/6 (rtc: s5m: Consolidate two device type switch statements)


Best regards,
Krzysztof


Krzysztof Kozlowski (6):
  mfd/rtc: sec/s5m: Rename SEC* symbols to S5M
  rtc: s5m: Remove undocumented time init on first boot
  rtc: s5m: Use shorter time of register update
  rtc: s5m: Support different register layout
  rtc: s5m: Add support for S2MPS14 RTC
  rtc: s5m: Consolidate two device type switch statements

 drivers/rtc/Kconfig             |   4 +-
 drivers/rtc/rtc-s5m.c           | 310 ++++++++++++++++++++++++++--------------
 include/linux/mfd/samsung/rtc.h |  86 ++++++-----
 3 files changed, 252 insertions(+), 148 deletions(-)

-- 
1.8.3.2

