Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaARCCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 21:02:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50801 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaARCCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 21:02:41 -0500
Message-ID: <52D9E0BE.2070500@infradead.org>
Date: Fri, 17 Jan 2014 18:02:38 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: KVM <kvm@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm: make KVM_MMU_AUDIT help text more readable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Make KVM_MMU_AUDIT kconfig help text readable and collapse
two spaces between words down to one space.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 arch/x86/kvm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-313-rc8.orig/arch/x86/kvm/Kconfig
+++ lnx-313-rc8/arch/x86/kvm/Kconfig
@@ -65,7 +65,7 @@ config KVM_MMU_AUDIT
 	depends on KVM && TRACEPOINTS
 	---help---
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
-	 audit  KVM MMU at runtime.
+	 auditing of KVM MMU events at runtime.
 
 config KVM_DEVICE_ASSIGNMENT
 	bool "KVM legacy PCI device assignment support"
