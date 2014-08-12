Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaHLM0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:26:40 -0400
Received: from m12-12.163.com ([220.181.12.12]:56223 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbaHLM0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:26:38 -0400
X-Coremail-DSSMTP: 180.110.160.105
From: weiyj_lk@163.com
To: Ralf Baechle <ralf@linux-mips.org>, Huacai Chen <chenhc@lemote.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] MIPS: Remove duplicated include from numa.c
Date: Tue, 12 Aug 2014 20:26:22 +0800
Message-Id: <1407846382-29951-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DMCowEDp2WDwB+pTt3oPAA--.584S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7WryUGr15JF4fXr4rXrWUJwb_yoWxKrgEka
	4a9w48G34fJF1xt3yxXrsrJ3y3W34UJ3WY9FnY9r1Svas8twsIgayDAw15Jr1a9wn0yrs3
	X3yrGr48ur1xKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5vfO7UUUUU==
X-Originating-IP: [180.110.160.105]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbibhLl1lD+JvezEgAAsR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/mips/loongson/loongson-3/numa.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/mips/loongson/loongson-3/numa.c b/arch/mips/loongson/loongson-3/numa.c
index ca025a6..37ed184 100644
--- a/arch/mips/loongson/loongson-3/numa.c
+++ b/arch/mips/loongson/loongson-3/numa.c
@@ -24,8 +24,6 @@
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
-#include <linux/bootmem.h>
-#include <linux/init.h>
 #include <linux/irq.h>
 #include <asm/bootinfo.h>
 #include <asm/mc146818-time.h>

