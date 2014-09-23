Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbaIWNx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:53:29 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:47542 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbaIWNx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:53:26 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Another KVM fix for 3.17
Date: Tue, 23 Sep 2014 15:53:18 +0200
Message-Id: <1411480398-18009-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit f3670394c29ff3730638762c1760fd2f624e6d7b:

  Revert "x86/efi: Fixup GOT in all boot code paths" (2014-09-22 23:05:49 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 954263938706bf62d36e81b6b49f313390f2ed35:

  Merge tag 'kvm-arm-for-v3.17-rc7-or-final' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master (2014-09-23 15:18:02 +0200)

----------------------------------------------------------------

Another fix for 3.17 arrived at just the wrong time, after I had sent
yesterday's pull request.  Normally I would have waited for
some other patches to pile up, but since 3.17 might be short
here it is.

----------------------------------------------------------------
Christoffer Dall (1):
      arm/arm64: KVM: Fix unaligned access bug on gicv2 access

Paolo Bonzini (1):
      Merge tag 'kvm-arm-for-v3.17-rc7-or-final' of git://git.kernel.org/.../kvmarm/kvmarm into kvm-master

 virt/kvm/arm/vgic-v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
