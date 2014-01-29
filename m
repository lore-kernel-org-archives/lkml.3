Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaA2RLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:11:37 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52086 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaA2RLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:11:35 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gleb@kernel.org,
        Vadim Rozenfeld <vrozenfe@redhat.com>
Subject: [PATCH] kvm: x86: move KVM_CAP_HYPERV_TIME outside #ifdef
Date: Wed, 29 Jan 2014 18:11:27 +0100
Message-Id: <1391015487-1404-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Self explanatory.

Reported-by: Radim Krcmar <rkrcmar@redhat.com>
Cc: Vadim Rozenfeld <vrozenfe@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34d0d610aa8a..39c28f09dfd5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2616,10 +2616,10 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_KVMCLOCK_CTRL:
 	case KVM_CAP_READONLY_MEM:
+	case KVM_CAP_HYPERV_TIME:
 #ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
 	case KVM_CAP_ASSIGN_DEV_IRQ:
 	case KVM_CAP_PCI_2_3:
-	case KVM_CAP_HYPERV_TIME:
 #endif
 		r = 1;
 		break;
-- 
1.8.3.1

