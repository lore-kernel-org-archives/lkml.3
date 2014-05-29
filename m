Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933776AbaE2Gtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:49:35 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:16680 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932614AbaE2Gte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:49:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At8QAALXhlNXQ3h6/2dsb2JhbABZgweCRahyCgUBmBgEAoEQF3SCZhwjGIECJBOIRgHXWYVViH2ERwEDj0CKNAGTKIM6Ow
Date: Thu, 29 May 2014 08:49:31 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3/3] init/calibrate.c: no prefix in logging
Message-Id: <20140529084931.cd55f441eac8083c9c33b48b@skynet.be>
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

