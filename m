Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab3FGXEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:04:46 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:52903 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab3FGXD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:56 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 31/31] mips/kvm: Allow for upto 8 KVM vcpus per vm.
Date: Fri,  7 Jun 2013 16:03:35 -0700
Message-Id: <1370646215-6543-32-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The mipsvz implementation allows for SMP, so let's be able to create
all those vcpus.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 9f209e1..0a5e218 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -20,7 +20,7 @@
 #include <linux/spinlock.h>
 
 
-#define KVM_MAX_VCPUS		1
+#define KVM_MAX_VCPUS		8
 #define KVM_USER_MEM_SLOTS	8
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 	0
-- 
1.7.11.7

