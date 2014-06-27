Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaF0GFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:05:37 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34413 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaF0GFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:05:36 -0400
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Himangi Saraogi <himangi774@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] spi: omap-uwire: fix compilation failure
Date: Thu, 26 Jun 2014 23:07:38 -0700
Message-Id: <1403849258-21779-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140620203858.GA14718@himangi-Dell>
References: <20140620203858.GA14718@himangi-Dell>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 'spi: omap-uwire: use devm_ functions' (b3f6a57506b8) introduced a
build error due to a missing include file. Add it.

Cc: Himangi Saraogi <himangi774@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Olof Johansson <olof@lixom.net>

---
 drivers/spi/spi-omap-uwire.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-omap-uwire.c b/drivers/spi/spi-omap-uwire.c
index cbf67f9..a05359c 100644
--- a/drivers/spi/spi-omap-uwire.c
+++ b/drivers/spi/spi-omap-uwire.c
@@ -38,6 +38,7 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
-- 
1.7.10.4

