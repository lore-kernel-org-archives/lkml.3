Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab3LMCLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:11:02 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:60784 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3LMCKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:10:44 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH V10 07/14] xen/x86: remove duplicated include from enlighten.c
Date: Thu, 12 Dec 2013 21:10:14 -0500
Message-Id: <1386900621-27528-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 500508d..0bfbe92 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -46,7 +46,6 @@
 #include <xen/hvm.h>
 #include <xen/hvc-console.h>
 #include <xen/acpi.h>
-#include <xen/features.h>
 
 #include <asm/paravirt.h>
 #include <asm/apic.h>
-- 
1.7.7.6

