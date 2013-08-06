Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3HFSQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:16:17 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34244 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab3HFSQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:16:12 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <gleb@redhat.com>, <mingo@redhat.com>, <jeremy@goop.org>, <x86@kernel.org>,
        <konrad.wilk@oracle.com>, <hpa@zytor.com>, <pbonzini@redhat.com>
Cc: <agraf@suse.de>, linux-doc@vger.kernel.org, <habanero@linux.vnet.ibm.com>,
        <riel@redhat.com>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <drjones@redhat.com>, <avi.kivity@gmail.com>, <peterz@infradead.org>,
        <chegu_vinod@hp.com>, <virtualization@lists.linux-foundation.org>,
        <torvalds@linux-foundation.org>, <tglx@linutronix.de>,
        <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
        <srivatsa.vaddagiri@gmail.com>, <ouyang@cs.pitt.edu>,
        <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 06 Aug 2013 23:52:16 +0530
Message-Id: <20130806182216.2386.39541.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20130806182150.2386.95104.sendpatchset@codeblue.in.ibm.com>
References: <20130806182150.2386.95104.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH V12 1/5] kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080618-7408-0000-0000-000012B87DB3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm uapi: Add KICK_CPU and PV_UNHALT definition to uapi

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

this is needed by both guest and host.

Originally-from: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/uapi/asm/kvm_para.h |    1 +
 include/uapi/linux/kvm_para.h        |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 06fdbd9..94dc8ca 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -23,6 +23,7 @@
 #define KVM_FEATURE_ASYNC_PF		4
 #define KVM_FEATURE_STEAL_TIME		5
 #define KVM_FEATURE_PV_EOI		6
+#define KVM_FEATURE_PV_UNHALT		7
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index cea2c5c..2841f86 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -19,6 +19,7 @@
 #define KVM_HC_MMU_OP			2
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_KICK_CPU			5
 
 /*
  * hypercalls use architecture specific

