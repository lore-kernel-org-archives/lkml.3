Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaCRIzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:55:11 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:52209 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaCRIzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:55:08 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Another KVM fix for 3.14 (PPC)
Date: Tue, 18 Mar 2014 09:55:00 +0100
Message-Id: <1395132900-1603-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit b73117c49364551ff789db7c424a115ac5b77850:

  Merge branch 'kvm-ppc-next' of git://github.com/agraf/linux-2.6 into kvm-queue (2014-01-29 18:29:01 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e724f080f5dd03881bc6d378750c37f7374cae7e:

  KVM: PPC: Book3S HV: Fix register usage when loading/saving VRSAVE (2014-03-13 10:47:01 +0100)

----------------------------------------------------------------
A fix for a PowerPC bug that was introduced during the 3.14 merge window.

----------------------------------------------------------------
Paul Mackerras (2):
      KVM: PPC: Book3S HV: Remove bogus duplicate code
      KVM: PPC: Book3S HV: Fix register usage when loading/saving VRSAVE

 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 71 +--------------------------------
 1 file changed, 2 insertions(+), 69 deletions(-)
