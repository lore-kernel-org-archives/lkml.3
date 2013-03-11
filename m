Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3CKOUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:20:06 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:58706 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3CKOUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:20:05 -0400
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 22:20:03 +0800
Message-ID: <CAPgLHd-xJ4+5e5UMMeF4G6RtWAb=xxDZ_JKE9tNZn057Eym8jw@mail.gmail.com>
Subject: [PATCH -next] char/tpm/tpm_i2c_stm_st33: remove duplicated include
 from tpm_i2c_stm_st33.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: key@linux.vnet.ibm.com, mail@srajiv.net, tpmdd@selhorst.net,
        tpmdd@sirrix.com
Cc: yongjun_wei@trendmicro.com.cn, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/char/tpm/tpm_i2c_stm_st33.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index 1f5f71e..4e42c62 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -36,7 +36,6 @@
 #include <linux/i2c.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/init.h>
@@ -50,7 +49,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 
 #include "tpm.h"
 #include "tpm_i2c_stm_st33.h"

