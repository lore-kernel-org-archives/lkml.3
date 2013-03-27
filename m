Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab3C0MVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:21:09 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:54079 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3C0MVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:21:07 -0400
Message-ID: <5152E41D.2030901@huawei.com>
Date: Wed, 27 Mar 2013 20:20:45 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: <davem@davemloft.net>
CC: <sparclinux@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparc:remove unused declaration smp_boot_cpus()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smp_boot_cpus() was replaced smp_prepare_cpus() long ago, and it no
longer needed, so delete it.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 arch/sparc/include/asm/smp_32.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/include/asm/smp_32.h b/arch/sparc/include/asm/smp_32.h
index b73da3c..68503d3 100644
--- a/arch/sparc/include/asm/smp_32.h
+++ b/arch/sparc/include/asm/smp_32.h
@@ -46,7 +46,6 @@ void sun4m_init_smp(void);
 void sun4d_init_smp(void);

 void smp_callin(void);
-void smp_boot_cpus(void);
 void smp_store_cpu_info(int);

 void smp_resched_interrupt(void);
-- 
1.6.0.2

