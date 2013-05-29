Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab3E2AAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:00:48 -0400
Received: from mail-la0-f68.google.com ([209.85.215.68]:52128 "EHLO
	mail-la0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3E2AAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:00:47 -0400
MIME-Version: 1.0
Date: Tue, 28 May 2013 20:00:45 -0400
Message-ID: <CABQQNFGaS9rKaWto75fVQ5Ru+XKU2hgBRBjnV8G6WGf_TeMt9g@mail.gmail.com>
Subject: [PATCH]: Definition for loglevel in KERN_OOPS
From: Christopher Sacchi <christophersacchi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch is for linux-3.10-rc2 and adds the definition for
KERN_OOPS (it can be used for whenever kernel oops occur) in
<linux/kern_loglevel.h> for <linux/printk.h>. It is below the
double-dashes.

--
Signed-off-by: Christopher P. Sacchi <christophersacchi@gmail.com>
--- include/linux/kern_levels.h 2013-05-20 17:38.000000000 -0400
+++ include/linux/kern_levels.h 2013-05-28 18:24:22.416100843 -0400
@@ -12,7 +12,7 @@
 #define KERN_NOTICE       KERN_SOH "5"          /* normal but
significant condition */
 #define KERN_INFO             KERN_SOH "6"          /* informational */
 #define KERN_DEBUG        KERN_SOH "7"          /* debug-level messages */
-
+#define KERN_OOPS         KERN_SOH "2"          /* kernel oops condition */
 #define KERN_DEFAULT     KERN_SOH "d"          /* the default kernel
loglevel */

 /*
--
