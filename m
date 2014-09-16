Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaIPVQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:16:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbaIPVQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:16:19 -0400
Subject: [PATCH] extcon: sm5502: Drop useless include
From: Jean Delvare <jdelvare@suse.de>
To: Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 16 Sep 2014 23:16:15 +0200
Message-ID: <1410902175.3951.28.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't include <linux/input.h> when the driver does not use anything
from this header file.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-sm5502.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/extcon/extcon-sm5502.c
+++ b/drivers/extcon/extcon-sm5502.c
@@ -17,7 +17,6 @@
 
 #include <linux/err.h>
 #include <linux/i2c.h>
-#include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
 #include <linux/kernel.h>

-- 
Jean Delvare
SUSE L3 Support

