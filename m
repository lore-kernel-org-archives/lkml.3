Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbaE2IPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:15:06 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:32464 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932560AbaE2IPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:15:01 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai4JACXrhlNXQ3h6/2dsb2JhbABZgweCRahyCgUBmB6BERd0gmYcIxiBAiQTiEYB11+FVYh9hEcBA49AijQBkyiDOjs
Date: Thu, 29 May 2014 10:14:58 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH V2 3/3] init/calibrate.c: no prefix in logging
Message-Id: <20140529101458.047becb88f3ba83196045465@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

define pr_fmt without prefix to avoid any default prefix update

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 init/calibrate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/init/calibrate.c b/init/calibrate.c
index fb9be44..169e98d 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -4,6 +4,8 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
+#define pr_fmt(fmt) fmt
+
 #include <linux/jiffies.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-- 
1.9.1

