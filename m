Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3JAOrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:47:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab3JAOrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:47:15 -0400
Date: Tue, 1 Oct 2013 17:47:12 +0300
From: Gleb Natapov <gleb@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [PULL] KVM fixes for 3.12-rc4
Message-ID: <20131001144712.GO11993@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 62d228b8c676232eca579f91cc0782b060a59097:

  Merge branch 'fixes' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2013-09-17 22:20:30 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

for you to fetch changes up to bcd1c2949501869631b25fd62d8df5079677a101:

  KVM: VMX: do not check bit 12 of EPT violation exit qualification when undefined (2013-09-25 11:38:26 +0200)

----------------------------------------------------------------
Gleb Natapov (1):
      KVM: VMX: do not check bit 12 of EPT violation exit qualification when undefined

Olof Johansson (1):
      ARM: kvm: rename cpu_reset to avoid name clash

 arch/arm/kvm/reset.c | 6 +++---
 arch/x86/kvm/vmx.c   | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)
--
			Gleb.
