Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaABVxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:53:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaABVxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:53:13 -0500
Date: Thu, 2 Jan 2014 19:52:26 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.13-rc6
Message-ID: <20140102215225.GA21472@amt.cnet>
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


Jan Kiszka (2):
      KVM: x86: Fix APIC map calculation after re-enabling
      KVM: nVMX: Unconditionally uninit the MMU on nested vmexit

 arch/x86/kvm/lapic.c |    8 ++++----
 arch/x86/kvm/vmx.c   |    3 +--
 2 files changed, 5 insertions(+), 6 deletions(-)
