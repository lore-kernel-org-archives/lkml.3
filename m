Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3H0Nlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:41:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65253 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3H0Nlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:41:51 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gnatapov@redhat.com
Subject: [PATCH 0/3] Trivial KVM patches for 3.12
Date: Tue, 27 Aug 2013 15:41:40 +0200
Message-Id: <1377610903-12356-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb,

these are fixups for the patches I sent on July 31.  It would
be nice to have them for the next merge window.

Thanks,

Paolo

Paolo Bonzini (3):
  KVM: rename __kvm_io_bus_sort_cmp to kvm_io_bus_cmp
  KVM: vmx: count exits to userspace during invalid guest emulation
  KVM: x86: add comments where MMIO does not return to the emulator

 arch/x86/kvm/vmx.c  |  1 +
 arch/x86/kvm/x86.c  |  7 +++++--
 virt/kvm/kvm_main.c | 16 ++++++++--------
 3 files changed, 14 insertions(+), 10 deletions(-)

-- 
1.8.3.1

