Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbaEIKKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:10:43 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33891 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbaEIKKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:10:40 -0400
Date: Fri, 9 May 2014 19:10:07 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: daeseok.youn@gmail.com, himangi774@gmail.com, sachin.kamat@linaro.org,
        fempsci@gmail.com, nandu.hgowda@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH 5/5] staging: cxt1e1: remove set a value to static variable
Message-ID: <20140509101007.GA6505@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cleanup checkpatch.pl error:
 ERROR: do not initialise statics to 0 or NULL

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/musycc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index c086c60..a87f802 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -1,5 +1,5 @@
-static unsigned int max_intcnt = 0;
-static unsigned int max_bh = 0;
+static unsigned int max_intcnt;
+static unsigned int max_bh;
 
 /*-----------------------------------------------------------------------------
  * musycc.c -
@@ -453,7 +453,7 @@ musycc_chan_restart(mch_t *ch)
 void
 rld_put_led(mpi_t *pi, u_int32_t ledval)
 {
-	static u_int32_t led = 0;
+	static u_int32_t led;
 
 	if (ledval == 0)
 		led = 0;
-- 
1.7.1

