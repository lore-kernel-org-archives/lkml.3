Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaHTJ3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:29:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24668 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaHTJ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:29:46 -0400
X-AuditID: cbfee61a-f79e46d00000134f-f0-53f46a886a1c
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: linux@roeck-us.net, Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] MAINTAINERS: add entry for the PWM fan driver
Date: Wed, 20 Aug 2014 11:29:23 +0200
Message-id: <1408526963-30524-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jQd2OrC/BBu8P8lv8eH2BzeLyrjls
	Fk8WnmGyuDNtL5sDi8eDibvZPHZ+b2D36NuyitHj8ya5AJYoLpuU1JzMstQifbsEroyPr16x
	FaxgrXh+8TNbA+M+li5GTg4JAROJW6/vQ9liEhfurWfrYuTiEBKYzijRfHc5O4TTwSRx99VK
	xi5GDg42AU2JVfc8QBpEBKwlLu95DRZmBrKPtfKDhIUF7CTOnNzFBGKzCKhK7DvWDWbzCrhI
	3L53iB2kXEJAQWLOJJsJjNwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgR7/pnUDsaV
	DRaHGAU4GJV4eBWyPwcLsSaWFVfmHmKU4GBWEuEtSvgSLMSbklhZlVqUH19UmpNafIhRmoNF
	SZz3QKt1oJBAemJJanZqakFqEUyWiYNTqoFRUuyPWn7CLhf20mwjz5cX5VK6rzc7e83l5l77
	59WWojcPPp7qej9hd/mnMP3bbQsaq+c+epIt73Rz/v+jYqcrl2xfX2S54ZYMg92GHccEX19X
	0v97ZY6xX6blpCszth28mPtEdEPybJ3MWS0tR/YJFeqm3gx1OpgitKzeZMH51o/2jOonlhRs
	UmIpzkg01GIuKk4EADIbQpr4AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 548602f..38e4765 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7244,6 +7244,14 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/pwc/*
 
+PWM FAN DRIVER
+M:	Kamil Debski <k.debski@samsung.com>
+L:	lm-sensors@lm-sensors.org
+S:	Supported
+F:	Documentation/devicetree/bindings/hwmon/pwm-fan.txt
+F:	Documentation/hwmon/pwm-fan
+F:	drivers/hwmon/pwm-fan.c
+
 PWM SUBSYSTEM
 M:	Thierry Reding <thierry.reding@gmail.com>
 L:	linux-pwm@vger.kernel.org
-- 
1.7.9.5

