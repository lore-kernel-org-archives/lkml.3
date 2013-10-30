Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab3J3LW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:22:59 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:39776 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3J3LW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:22:57 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, tim.gardner@canonical.com, gleb@redhat.com
Subject: [GIT PULL] KVM fixes for 3.12
Date: Wed, 30 Oct 2013 12:22:50 +0100
Message-Id: <1383132170-6063-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 7314e613d5ff9f0934f7a0f74ed7973b903315d1:

  Fix a few incorrectly checked [io_]remap_pfn_range() calls (2013-10-29 10:21:34 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 0c8eb04a6241da28deb108181213b791c378123b:

  KVM: use a more sensible error number when debugfs directory creation fails (2013-10-30 12:15:34 +0100)

----------------------------------------------------------------
Fixes for the 3.12 debugfs problem---removing the duplicate directory
name, and using a better the error code.

----------------------------------------------------------------
Paolo Bonzini (1):
      KVM: use a more sensible error number when debugfs directory creation fails

Tim Gardner (1):
      KVM: Fix modprobe failure for kvm_intel/kvm_amd

 arch/x86/kernel/kvm.c | 2 +-
 virt/kvm/kvm_main.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
