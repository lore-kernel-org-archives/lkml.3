Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab3EWKlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:41:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758012Ab3EWKlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:41:08 -0400
Date: Thu, 23 May 2013 13:41:05 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, pbonzini@redhat.com
Subject: [GIT PULL] KVM fixes for 3.10-rc2
Message-ID: <20130523104105.GA6826@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive the following KVM bug fixes


Paolo Bonzini (1):
      KVM: take over co-maintainership from Marcelo, fix MAINTAINERS entry

Sanjay Lal (2):
      KVM/MIPS32: Move include/asm/kvm.h => include/uapi/asm/kvm.h since it is a user visible API.
      KVM/MIPS32: Wrap calls to gfn_to_pfn() with srcu_read_lock/unlock()

 MAINTAINERS                      |    7 ++--
 arch/mips/include/asm/kvm.h      |   55 ---------------------------------------
 arch/mips/include/uapi/asm/kvm.h |   55 +++++++++++++++++++++++++++++++++++++++
 arch/mips/kvm/kvm_tlb.c          |   35 ++++++++++++++++++------
 4 files changed, 85 insertions(+), 67 deletions(-)

--
			Gleb.
