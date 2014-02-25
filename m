Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaBYRt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:49:26 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:37982 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbaBYRtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:49:25 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, mtosatti@redhat.com, jan.kiszka@siemens.com,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: [PATCH 0/2] KVM: x86: more xsave and mpx improvements
Date: Tue, 25 Feb 2014 18:49:16 +0100
Message-Id: <1393350558-11461-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the patches I mentioned while reviewing Liu Jinsong's MPX
series.

Patch 1 is a further cleanup of xcr0 handling, and patch 2 introduces
nested virtualization support for MPX.

Please review.

Thanks,

Paolo

Paolo Bonzini (2):
  KVM: x86: introduce kvm_supported_xcr0()
  KVM: x86: Add nested virtualization support for MPX

 arch/x86/kvm/cpuid.c | 27 ++++++++++++++++-----------
 arch/x86/kvm/vmx.c   | 16 ++++++++++++++++
 arch/x86/kvm/x86.c   |  4 +---
 arch/x86/kvm/x86.h   |  2 ++
 4 files changed, 35 insertions(+), 14 deletions(-)

-- 
1.8.3.1

