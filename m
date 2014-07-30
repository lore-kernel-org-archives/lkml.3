Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaG3NcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:32:03 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53751 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaG3NcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:32:00 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL] Final KVM change for 3.16
Date: Wed, 30 Jul 2014 15:31:46 +0200
Message-Id: <1406727106-15262-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit bb18b526a9d8d4a3fe56f234d5013b9f6036978d:

  Merge tag 'signed-for-3.16' of git://github.com/agraf/linux-2.6 into kvm-master (2014-07-08 12:08:58 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 63afbe7a0ac184ef8485dac4914e87b211b5bfaa:

  kvm: arm64: vgic: fix hyp panic with 64k pages on juno platform (2014-07-30 14:35:42 +0200)

----------------------------------------------------------------
Fix a bug which allows KVM guests to bring down the entire system
on some 64K enabled ARM64 hosts.

----------------------------------------------------------------
Will Deacon (1):
      kvm: arm64: vgic: fix hyp panic with 64k pages on juno platform

 virt/kvm/arm/vgic.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)
