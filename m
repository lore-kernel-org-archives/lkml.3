Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3CKOWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:22:44 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:38493 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3CKOWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:22:43 -0400
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 22:22:42 +0800
Message-ID: <CAPgLHd-U-AJkPpWiRXQO5Nyod_AGE=EKHBQTEmTPzAfGfUBx8w@mail.gmail.com>
Subject: [PATCH -next] staging: comedi: remove duplicated include from ni_pcimio.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org
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
 drivers/staging/comedi/drivers/ni_pcimio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 98b43f2..2b52fd0 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -111,7 +111,6 @@ Bugs:
 */
 
 #include <linux/delay.h>
-#include <linux/delay.h>
 
 #include "../comedidev.h"
 

