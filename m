Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbbAWM7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:59:35 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:53295 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbbAWM7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:59:33 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.19-rc6
Date: Fri, 23 Jan 2015 13:59:21 +0100
Message-Id: <1422017961-1733-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc:

  Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to f3747379accba8e95d70cec0eae0582c8c182050:

  KVM: x86: SYSENTER emulation is broken (2015-01-23 13:57:15 +0100)

----------------------------------------------------------------
Three small fixes.  Two for x86 and one avoids that sparse bails out.

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: fix sparse warning in include/trace/events/kvm.h

Nadav Amit (2):
      KVM: x86: Fix of previously incomplete fix for CVE-2014-8480
      KVM: x86: SYSENTER emulation is broken

 arch/x86/kvm/emulate.c     | 31 ++++++++++---------------------
 include/trace/events/kvm.h | 16 +++++++++-------
 2 files changed, 19 insertions(+), 28 deletions(-)
