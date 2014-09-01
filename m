Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaIAIgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:36:51 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44933 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaIAIgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:36:50 -0400
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, gleb@kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, cornelia.huck@de.ibm.com,
        xiantao.zhang@intel.com, agraf@suse.de
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH] KVM: EVENTFD: remove inclusion of irq.h
Date: Mon,  1 Sep 2014 10:36:08 +0200
Message-Id: <1409560568-6911-1-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more needed. irq.h would be void on ARM.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

I don't think irq.h is needed anymore since Paul Mackerras' work. However
I did not compile for all architectures.
---
 virt/kvm/eventfd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 3c5981c..0c712a7 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -36,7 +36,6 @@
 #include <linux/seqlock.h>
 #include <trace/events/kvm.h>
 
-#include "irq.h"
 #include "iodev.h"
 
 #ifdef CONFIG_HAVE_KVM_IRQFD
-- 
1.9.1

