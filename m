Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3G2Ed1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:33:27 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:58984 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3G2Ed0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:33:26 -0400
MIME-Version: 1.0
Date: Mon, 29 Jul 2013 12:33:24 +0800
Message-ID: <CAPgLHd8hRfrRpgLMJTmno49FBNEUO8_tkyLRmuBoBh9gssRtGA@mail.gmail.com>
Subject: [PATCH -next] staging: gdm724x: remove duplicated include from gdm_lte.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, wonkang@gctsemi.com, joe@perches.com,
        sachin.kamat@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/gdm724x/gdm_lte.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
index 68ebc7d..7165d3a 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -21,9 +21,7 @@
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
-#include <linux/in.h>
 #include <linux/in6.h>
-#include <linux/udp.h>
 #include <linux/tcp.h>
 #include <linux/icmp.h>
 #include <linux/icmpv6.h>

