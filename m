Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaFEHZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:25:53 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:54053 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaFEHZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:25:51 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 0/3] Prepare for in-kernel VFIO DMA operations acceleration
Date: Thu,  5 Jun 2014 17:25:41 +1000
Message-Id: <1401953144-19186-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060507-3568-0000-0000-000005A14B6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reserves 2 capability numbers.

This implements an extended version of KVM_CREATE_SPAPR_TCE_64 ioctl.

Please advise how to proceed with these patches as I suspect that
first two should go via Paolo's tree while the last one via Alex Graf's tree
(correct?).

Thanks!

Alexey Kardashevskiy (3):
  PPC: KVM: Reserve KVM_CAP_SPAPR_TCE_VFIO capability number
  PPC: KVM: Reserve KVM_CAP_SPAPR_TCE_64 capability number
  PPC: KVM: Add support for 64bit TCE windows

 Documentation/virtual/kvm/api.txt   | 46 +++++++++++++++++++++++++++++++++++++
 arch/powerpc/include/asm/kvm_host.h |  4 +++-
 arch/powerpc/include/asm/kvm_ppc.h  |  2 +-
 arch/powerpc/include/uapi/asm/kvm.h |  9 ++++++++
 arch/powerpc/kvm/book3s_64_vio.c    |  4 +++-
 arch/powerpc/kvm/powerpc.c          | 24 ++++++++++++++++++-
 include/uapi/linux/kvm.h            |  4 ++++
 7 files changed, 89 insertions(+), 4 deletions(-)

-- 
2.0.0

