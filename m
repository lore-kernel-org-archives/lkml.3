Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3J3WcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:32:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab3J3WcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:32:21 -0400
Date: Thu, 31 Oct 2013 00:34:56 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Yang Zhang <yang.z.zhang@Intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kvm/vmx: error message typo fix
Message-ID: <20131030223456.GA18423@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mst can't be blamed for lack of switch entries: the
issue is with msrs actually.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2b2fce1..e4de4fe 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1498,7 +1498,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 			break;
 
 	if (i == NR_AUTOLOAD_MSRS) {
-		printk_once(KERN_WARNING"Not enough mst switch entries. "
+		printk_once(KERN_WARNING "Not enough msr switch entries. "
 				"Can't add msr %x\n", msr);
 		return;
 	} else if (i == m->nr) {
-- 
MST
