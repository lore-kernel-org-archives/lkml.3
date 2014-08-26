Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbaHZObg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:31:36 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42971 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbaHZObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:31:34 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-d1-53fc9a4301b0
From: Tomasz Figa <t.figa@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH] MAINTAINERS: Tomasz has moved
Date: Tue, 26 Aug 2014 16:30:53 +0200
Message-id: <1409063453-16124-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xq7rOs/4EG9zdKWMx5c9yJotNj6+x
	WlzeNYfNYsb5fUwWa4/cZbd4OuEim8XhN+2sFutnvGZx4PC4c20Pm8fmJfUefVtWMXp83iQX
	wBLFZZOSmpNZllqkb5fAlTH9+mnmgpecFZsXHGFrYJzD0cXIySEhYCJx7dpCVghbTOLCvfVs
	XYxcHEICSxklznX/YgZJCAn0MUmcmC8GYrMJqEl8bnjEBmKLCChIbO59BtbMLLCQSWLdbx4Q
	W1hAT6Ll5gmwGhYBVYk7+1+xgNi8Ak4SK/ffYIFYJiexauM+pgmM3AsYGVYxiqaWJhcUJ6Xn
	GuoVJ+YWl+al6yXn525ihITIlx2Mi49ZHWIU4GBU4uH9UPI7WIg1say4MvcQowQHs5II74+k
	P8FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGIv+31u39cmsRclq1e0t5io9b+PCA9lnnnl4TsD1
	icyLkKCiV349tf/C5i46I+qYIBh9/PsG/ViOuSphPwue1xaV+CWIuG3eeeraYZaHLHobHZK6
	bP7Xnlye9jz9p8letk03ypjVWWuVFzAkvzVney/yuq34cf+5xw/5SvsqXk/1fNa2vtXfW4ml
	OCPRUIu5qDgRABqrtN3vAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am leaving Samsung, so my current e-mail address is not going to work
any longer. Replace it with my private one. In addition, Sylwester
Nawrocki is being added as co-maintainer for Samsung clock drivers to
take some of the responsibilities, as I will be doing my part in my spare
time.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 MAINTAINERS | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index acd44c3..d57f6ce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7062,7 +7062,7 @@ S:	Maintained
 F:	drivers/pinctrl/sh-pfc/
 
 PIN CONTROLLER - SAMSUNG
-M:	Tomasz Figa <t.figa@samsung.com>
+M:	Tomasz Figa <tomasz.figa@gmail.com>
 M:	Thomas Abraham <thomas.abraham@linaro.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
@@ -7908,7 +7908,8 @@ S:	Supported
 F:	drivers/media/i2c/s5k5baf.c
 
 SAMSUNG SOC CLOCK DRIVERS
-M:	Tomasz Figa <t.figa@samsung.com>
+M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
+M:	Tomasz Figa <tomasz.figa@gmail.com>
 S:	Supported
 L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 F:	drivers/clk/samsung/
-- 
2.0.4

