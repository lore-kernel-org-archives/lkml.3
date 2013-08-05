Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3HEWE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:04:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:64992 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab3HEWDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="382341521"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 16/16] x86, asmlinkage, vdso: Mark vdso variables __visible
Date: Mon,  5 Aug 2013 15:02:50 -0700
Message-Id: <1375740170-7446-17-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/vvar.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index de656ac..d76ac40 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -35,7 +35,7 @@
 
 #define DEFINE_VVAR(type, name)						\
 	type name							\
-	__attribute__((section(".vvar_" #name), aligned(16)))
+	__attribute__((section(".vvar_" #name), aligned(16))) __visible
 
 #define VVAR(name) (*vvaraddr_ ## name)
 
-- 
1.8.3.1

