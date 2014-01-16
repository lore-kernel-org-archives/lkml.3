Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaAPLpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:45:31 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:56191 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAPLp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:45:27 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org.com, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.13 final
Date: Thu, 16 Jan 2014 12:45:16 +0100
Message-Id: <1389872716-1451-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 7e22e91102c6b9df7c4ae2168910e19d2bb14cd6:

  Linux 3.13-rc8 (2014-01-12 17:04:18 +0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 0dce7cd67fd9055c4a2ff278f8af1431e646d346:

  kvm: x86: fix apic_base enable check (2014-01-15 13:42:14 +0100)

----------------------------------------------------------------
Fix for a brown paper bag bug.  Thanks to Drew Jones for noticing.

----------------------------------------------------------------
Andrew Jones (1):
      kvm: x86: fix apic_base enable check

 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
