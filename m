Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab3F0FDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:03:10 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61638 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3F0FDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:03:07 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 2/8] KVM: PPC: reserve a capability and ioctl numbers for realmode VFIO
Date: Thu, 27 Jun 2013 15:02:30 +1000
Message-Id: <1372309356-28320-3-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 include/uapi/linux/kvm.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 970b1f5..0865c01 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -667,6 +667,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_RTAS 91
 #define KVM_CAP_IRQ_XICS 92
 #define KVM_CAP_SPAPR_MULTITCE 93
+#define KVM_CAP_SPAPR_TCE_IOMMU 94
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -923,6 +924,7 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_PPC_ALLOC_HTAB */
 #define KVM_PPC_ALLOCATE_HTAB	  _IOWR(KVMIO, 0xa7, __u32)
 #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_spapr_tce)
+#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xaf, struct kvm_create_spapr_tce_iommu)
 /* Available with KVM_CAP_RMA */
 #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
 /* Available with KVM_CAP_PPC_HTAB_FD */
-- 
1.7.10.4

