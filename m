Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3BAHH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 02:07:59 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:2212 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab3BAHHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 02:07:49 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, fabio.porcedda@gmail.com,
        JM.Lin@atmel.com, wenyou.yang@atmel.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/8] watchdog/at91sam9_wdt: Remove the __initdata of at91wdt_wdd
Date: Fri,  1 Feb 2013 15:06:24 +0800
Message-Id: <1359702386-21284-7-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com>
References: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 01 Feb 2013 07:07:29.0200 (UTC) FILETIME=[CC179300:01CE004A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For this variable will be used in the timer handler.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/watchdog/at91sam9_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index e60a718..3fc90ba 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -199,7 +199,7 @@ static struct watchdog_ops at91wdt_ops = {
 	.ping = at91wdt_ping,
 };
 
-static struct watchdog_device at91wdt_wdd __initdata = {
+static struct watchdog_device at91wdt_wdd = {
 	.timeout = WDT_HEARTBEAT,
 	.min_timeout = MIN_HEARTBEAT,
 	.max_timeout = MAX_HEARTBEAT,
-- 
1.7.9.5

