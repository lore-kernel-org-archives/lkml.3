Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbaAITqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 14:46:05 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:57409 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910AbaAITpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:45:46 -0500
From: Anmol Sarma <me@anmolsarma.in>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, Anmol Sarma <me@anmolsarma.in>
Subject: [PATCH v2 2/3] Staging: rtl8187se: r8180_wx.c: make 'rtl8180_rates' static
Date: Fri, 10 Jan 2014 01:14:43 +0530
Message-Id: <8697640a9852326c352d4967018c1f2421e3a3e6.1389295289.git.me@anmolsarma.in>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1389295289.git.me@anmolsarma.in>
References: <20140109151518.GS30234@mwanda>
 <cover.1389295289.git.me@anmolsarma.in>
In-Reply-To: <cover.1389295289.git.me@anmolsarma.in>
References: <cover.1389295289.git.me@anmolsarma.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warning:
27:5: warning: symbol 'rtl8180_rates' was not declared. Should it be static?

Signed-off-by: Anmol Sarma <me@anmolsarma.in>
---
 drivers/staging/rtl8187se/r8180_wx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index bae6875..85099bb 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -24,7 +24,7 @@
 #include <net/iw_handler.h>
 #include "ieee80211/dot11d.h"
 
-u32 rtl8180_rates[] = {1000000, 2000000, 5500000, 11000000,
+static u32 rtl8180_rates[] = {1000000, 2000000, 5500000, 11000000,
 	6000000, 9000000, 12000000, 18000000, 24000000, 36000000, 48000000, 54000000};
 
 #define RATE_COUNT ARRAY_SIZE(rtl8180_rates)
-- 
1.8.3.2

