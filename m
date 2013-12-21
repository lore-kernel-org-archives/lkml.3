Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3LUK2f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:28:35 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33271 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab3LUK2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:28:34 -0500
Date: Sat, 21 Dec 2013 15:58:25 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lidza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        josh@joshtriplett.org
Subject: [PATCH 2/2] drivers: dgap: Include appropriate header file in
 dgap_trace.c
Message-ID: <20131221102825.GA3257@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file dgap/dgap_trace.h in dgap_trace.c
because function dgap_tracer_free() have its prototype declaration in
the header file.

This eliminates the following warning in dgap_trace.c:
drivers/staging/dgap/dgap_trace.c:181:6: warning: no previous prototype for ‘dgap_tracer_free’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/staging/dgap/dgap_trace.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/dgap/dgap_trace.c b/drivers/staging/dgap/dgap_trace.c
index 0f9a956..6c8b510 100644
--- a/drivers/staging/dgap/dgap_trace.c
+++ b/drivers/staging/dgap/dgap_trace.c
@@ -37,6 +37,7 @@
 #include <linux/vmalloc.h>
 
 #include "dgap_driver.h"
+#include "dgap_trace.h"
 
 #define TRC_TO_CONSOLE 1
 
-- 
1.7.9.5

