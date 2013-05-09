Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab3EINvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933Ab3EINvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:51:39 -0400
Date: Thu, 9 May 2013 16:51:36 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for the 3.10 merge window
Message-ID: <20130509135136.GA9616@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.10-2

to receive the KVM fixes for the 3.10 merge window. Most of the fixes
are in the emulator since now we emulate more than we did before for
correctness sake we see more bugs there, but there is also an OOPS fixed
and corruption of xcr0 register.


Asias He (1):
      KVM: Fix kvm_irqfd_init initialization

Gleb Natapov (1):
      KVM: VMX: fix halt emulation while emulating invalid guest sate

Marcelo Tosatti (1):
      KVM: x86: fix maintenance of guest/host xcr0 state

Paolo Bonzini (3):
      KVM: emulator: emulate AAM
      KVM: emulator: emulate XLAT
      KVM: emulator: emulate SALC

 arch/x86/kvm/emulate.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx.c     |    6 ++++++
 arch/x86/kvm/x86.c     |   40 ++++++++++++++++++++--------------------
 virt/kvm/kvm_main.c    |   18 +++++++++++++-----
 4 files changed, 80 insertions(+), 26 deletions(-)
--
			Gleb.
