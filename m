Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaGKNxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:53:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:56172 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaGKNol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:44:41 -0400
Message-Id: <20140711133707.671837404@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:44:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 28/55] time-export-nsecs-to-jiffies.patch
References: <20140711133623.530368377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=time-export-nsecs-to-jiffies.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/time.c |    1 +
 1 file changed, 1 insertion(+)

Index: tip/kernel/time/time.c
===================================================================
--- tip.orig/kernel/time/time.c
+++ tip/kernel/time/time.c
@@ -757,6 +757,7 @@ unsigned long nsecs_to_jiffies(u64 n)
 {
 	return (unsigned long)nsecs_to_jiffies64(n);
 }
+EXPORT_SYMBOL_GPL(nsecs_to_jiffies);
 
 /*
  * Add two timespec values and do a safety check for overflow.


