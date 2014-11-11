Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaKKO2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:28:42 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:61839 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaKKO2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:28:40 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 3.18-rc5
Date: Tue, 11 Nov 2014 15:28:32 +0100
Message-Id: <1415716112-9462-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to d29b9d7ed76c0b961603ca692b8a562556a20212:

  KVM: x86: Fix uninitialized op->type for some immediate values (2014-11-05 12:36:58 +0100)

----------------------------------------------------------------
Two fixes---one of them not exactly a one liner, but things are
calming down on the KVM front at last.

----------------------------------------------------------------
Nadav Amit (1):
      KVM: x86: Fix uninitialized op->type for some immediate values

Paolo Bonzini (1):
      Merge tag 'kvm-s390-20141103' of git://git.kernel.org/.../kvms390/linux into kvm-master

Sebastian Ott (1):
      KVM: s390: virtio_ccw: remove unused variable

 arch/x86/kvm/emulate.c        | 8 ++++++++
 drivers/s390/kvm/virtio_ccw.c | 1 -
 2 files changed, 8 insertions(+), 1 deletion(-)
