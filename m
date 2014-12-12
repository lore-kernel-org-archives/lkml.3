Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934770AbaLLUK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:10:57 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:53988 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaLLUKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:10:55 -0500
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] extcon-class: kill duplicate #include
Date: Fri, 12 Dec 2014 23:10:51 +0300
Message-ID: <157607795.iq96eyHTpY@wasted.cogentembedded.com>
Organization: Cogent Embedded Inc.
User-Agent: KMail/4.14.3 (Linux/3.17.4-200.fc20.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f841afb17476f485900bb6213cf93a64a7dc303f (extcon: Implement OF-based
extcon lookup properly) added #include <linux/of.h> (I didn't even understand
why), while such #include was already there.  Kill the duplicate #include.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
The patch is against the 'extcon-next' branch of the 'extcon.git' repo.

 drivers/extcon/extcon-class.c |    1 -
 1 file changed, 1 deletion(-)

Index: extcon/drivers/extcon/extcon-class.c
===================================================================
--- extcon.orig/drivers/extcon/extcon-class.c
+++ extcon/drivers/extcon/extcon-class.c
@@ -29,7 +29,6 @@
 #include <linux/fs.h>
 #include <linux/err.h>
 #include <linux/extcon.h>
-#include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/of.h>

