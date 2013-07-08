Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3GHHvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:51:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab3GHHvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:51:43 -0400
Date: Mon, 8 Jul 2013 10:51:41 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: [GIT PULL] more KVM changes for 3.11
Message-ID: <20130708075141.GA9165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.11-2

to receive more KVM updates for the 3.11 merge window. There is a fix for
a bug that prevents some guests from working on old Intel CPUs and a patch
that integrates ARM64 KVM, merged via ARM64 tree, into Kconfig.

----------------------------------------------------------------
Gleb Natapov (1):
      KVM: VMX: mark unusable segment as nonpresent

Marc Zyngier (1):
      arm64: KVM: Kconfig integration

 arch/arm64/Kconfig              |    2 ++
 arch/arm64/kernel/asm-offsets.c |    1 +
 arch/arm64/kvm/Kconfig          |   51 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx.c              |   11 +++++++--
 4 files changed, 63 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/Kconfig
--
			Gleb.
