Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbaHYMT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:19:57 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59358 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbaHYMTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:19:34 -0400
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com
Subject: [PATCH v2 1/2] KVM: EVENTFD: remove inclusion of irq.h
Date: Mon, 25 Aug 2014 14:18:58 +0200
Message-Id: <1408969139-14700-2-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408969139-14700-1-git-send-email-eric.auger@linaro.org>
References: <1408969139-14700-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more needed. Also irq.h is not used on ARM.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
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

