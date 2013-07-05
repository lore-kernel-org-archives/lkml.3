Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3GEVDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 17:03:23 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:54678 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3GEVDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 17:03:21 -0400
From: Aldo Iljazi <neonsync1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Aldo Iljazi <neonsync1@gmail.com>
Subject: [PATCH] Staging: csr: csr_wifi_router_sef.c: fixed a brace coding style issue
Date: Sat,  6 Jul 2013 00:03:14 +0300
Message-Id: <1373058194-7961-1-git-send-email-neonsync1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Aldo Iljazi <neonsync1@gmail.com>
---
 drivers/staging/csr/csr_wifi_router_sef.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/csr/csr_wifi_router_sef.c b/drivers/staging/csr/csr_wifi_router_sef.c
index 45a10fb..bdb7d3b 100644
--- a/drivers/staging/csr/csr_wifi_router_sef.c
+++ b/drivers/staging/csr/csr_wifi_router_sef.c
@@ -9,8 +9,7 @@
  *****************************************************************************/
 #include "csr_wifi_router_sef.h"
 
-const CsrWifiRouterStateHandlerType CsrWifiRouterDownstreamStateHandlers[CSR_WIFI_ROUTER_PRIM_DOWNSTREAM_COUNT] =
-{
+const CsrWifiRouterStateHandlerType CsrWifiRouterDownstreamStateHandlers[CSR_WIFI_ROUTER_PRIM_DOWNSTREAM_COUNT] = {
     /* 0x0000 */ CsrWifiRouterMaPacketSubscribeReqHandler,
     /* 0x0001 */ CsrWifiRouterMaPacketUnsubscribeReqHandler,
     /* 0x0002 */ CsrWifiRouterMaPacketReqHandler,
-- 
1.7.9.5

