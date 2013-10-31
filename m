Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3JaKzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:55:04 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:49428 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3JaKyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:54:54 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3/3] Documentation/kvm: add a 00-INDEX file
Date: Thu, 31 Oct 2013 16:16:36 +0530
Message-Id: <1383216396-12869-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0
In-Reply-To: <1383216396-12869-1-git-send-email-artagnon@gmail.com>
References: <1383216396-12869-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 Documentation/virtual/kvm/00-INDEX | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/virtual/kvm/00-INDEX

diff --git a/Documentation/virtual/kvm/00-INDEX b/Documentation/virtual/kvm/00-INDEX
new file mode 100644
index 0000000..1d339cd
--- /dev/null
+++ b/Documentation/virtual/kvm/00-INDEX
@@ -0,0 +1,24 @@
+00-INDEX
+	- this file.
+api.txt
+	- the definitive KVM API documentation.
+cpuid.txt
+	- notes on KVM cpuid functions.
+devices/
+	- directory with info on device bindings for KVM_CAP_DEVICE_CTRL.
+hypercalls.txt
+	- info on the KVM hypercalls.
+locking.txt
+	- notes on KVM locks.
+mmu.txt
+	- the x86 kvm shadow mmu.
+msr.txt
+	- list of custom MSRs in KVM.
+nested-vmx.txt
+	- notes on a feature enabling nested VMX guests.
+ppc-pv.txt
+	- the paravirtualization interface on PowerPC.
+review-checklist.txt
+	- review checklist for KVM patches.
+timekeeping.txt
+	- info on timekeeping virtualization for x86-based architectures.
-- 
1.8.5.rc0

