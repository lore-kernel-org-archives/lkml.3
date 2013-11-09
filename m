Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab3KICR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 21:17:56 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48766 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939Ab3KICRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 21:17:52 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH] MAINTAINERS: Add entry for Samsung SoC clock drivers
Date: Sat,  9 Nov 2013 03:17:34 +0100
Message-Id: <1383963454-2749-1-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch adds an entry for Samsung SoC clock drivers located under
drivers/clk/samsung/ directory, with me taking the maintainer role.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Mike Turquette <mturquette@linaro.org>
Acked-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 61b8757..df7e1bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7319,6 +7319,12 @@ L:	linux-media@vger.kernel.org
 S:	Supported
 F:	drivers/media/i2c/s5c73m3/*
 
+SAMSUNG SOC CLOCK DRIVERS
+M:	Tomasz Figa <t.figa@samsung.com>
+S:	Supported
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
+F:	drivers/clk/samsung/
+
 SERIAL DRIVERS
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-serial@vger.kernel.org
-- 
1.8.4.2

