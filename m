Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3JQOuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:50:55 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40710 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3JQOuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:50:54 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, agraf@suse.de, chao.zhou@intel.com, magnus@boden.cx,
        kvm@vger.kernel.org
Subject: [PATCH 0/2] KVM_SET_XCRS fixes
Date: Thu, 17 Oct 2013 16:50:45 +0200
Message-Id: <1382021447-20216-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch fixes bugs 63121 and 63131 (yeah, all kernel bugs
end with 1).  The second patch fixes a typo (the same typo exists
in QEMU).

Paolo Bonzini (2):
  KVM: x86: fix KVM_SET_XCRS for CPUs that do not support XSAVE
  KVM: x86: fix KVM_SET_XCRS loop

 arch/x86/kvm/x86.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

-- 
1.8.3.1

