Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab3FJTeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:34:36 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:65007 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3FJTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:33:58 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 1/2] kvm: Add definition of KVM_REG_MIPS
Date: Mon, 10 Jun 2013 12:33:47 -0700
Message-Id: <1370892828-21676-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370892828-21676-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370892828-21676-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

We use 0x7000000000000000ULL as 0x6000000000000000ULL is reserved for
ARM64.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a5c86fc..d88c8ee 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -783,6 +783,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_IA64		0x3000000000000000ULL
 #define KVM_REG_ARM		0x4000000000000000ULL
 #define KVM_REG_S390		0x5000000000000000ULL
+#define KVM_REG_MIPS		0x7000000000000000ULL
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
-- 
1.7.11.7

