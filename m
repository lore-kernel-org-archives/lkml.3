Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaAGNhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:37:17 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:46252 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAGNhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:37:10 -0500
MIME-Version: 1.0
Date: Tue, 7 Jan 2014 21:37:09 +0800
Message-ID: <CAPgLHd-ADur1e3T_jBFK7=+s+j4ggRVKutqYBS0pXMbtDSdjOA@mail.gmail.com>
Subject: [PATCH -next] xen/pvh: remove duplicated include from enlighten.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Cc: yongjun_wei@trendmicro.com.cn, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/x86/xen/enlighten.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a4e2f30..b6d61c3 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -46,7 +46,6 @@
 #include <xen/hvm.h>
 #include <xen/hvc-console.h>
 #include <xen/acpi.h>
-#include <xen/features.h>
 
 #include <asm/paravirt.h>
 #include <asm/apic.h>

