Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab3LNNH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:07:28 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46980 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3LNNHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:07:25 -0500
Date: Sat, 14 Dec 2013 18:37:18 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, josh@joshtriplett.org
Subject: [PATCH] drivers: memstick: Mark function
 memstick_debug_get_tpc_name() as static in r592.c
Message-ID: <20131214130717.GA8361@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function memstick_debug_get_tpc_name() as static in
host/r592.c because it is not used outside this file.

Thus, it also eliminates the following warning in host/r592.c:
drivers/memstick/host/r592.c:50:13: warning: no previous prototype for ‘memstick_debug_get_tpc_name’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/memstick/host/r592.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index 31727bf..1cd9307 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -47,7 +47,7 @@ static const char *tpc_names[] = {
  * memstick_debug_get_tpc_name - debug helper that returns string for
  * a TPC number
  */
-const char *memstick_debug_get_tpc_name(int tpc)
+static const char *memstick_debug_get_tpc_name(int tpc)
 {
 	return tpc_names[tpc-1];
 }
-- 
1.7.9.5

