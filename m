Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab3CSWfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:35:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab3CSWfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:35:20 -0400
Date: Tue, 19 Mar 2013 19:35:04 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.9-rc3
Message-ID: <20130319223504.GA21944@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: ~/inbox/sent-mutt-Aug-2012
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive the following KVM bug fixes


Andy Honig (3):
      KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME (CVE-2013-1796)
      KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use gfn_to_hva_cache functions (CVE-2013-1797)
      KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)

Kevin Hilman (1):
      KVM: allow host header to be included even for !CONFIG_KVM

Marcelo Tosatti (1):
      KVM: x86: fix deadlock in clock-in-progress request handling

 arch/x86/include/asm/kvm_host.h |    4 +-
 arch/x86/kvm/x86.c              |   70 +++++++++++++++++++---------------------
 include/linux/kvm_host.h        |    7 +++-
 virt/kvm/ioapic.c               |    7 ++--
 4 files changed, 47 insertions(+), 41 deletions(-)
