Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249Ab3JONI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:08:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758664Ab3JONIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:08:24 -0400
Date: Tue, 15 Oct 2013 16:08:21 +0300
From: Gleb Natapov <gleb@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PULL] KVM fixes for 3.12-rc6
Message-ID: <20131015130821.GA15657@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull one fix for pvspinlock below.

The following changes since commit 9d05746e7b16d8565dddbe3200faa1e669d23bbf:

  vfs: allow O_PATH file descriptors for fstatfs() (2013-10-12 13:12:31 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

for you to fetch changes up to 3dbef3e3bf13d74582fe43548f5c570a0cec9b20:

  KVM: Enable pvspinlock after jump_label_init() to avoid VM hang (2013-10-15 14:15:54 +0300)

----------------------------------------------------------------
Raghavendra K T (1):
      KVM: Enable pvspinlock after jump_label_init() to avoid VM hang

 arch/x86/kernel/kvm.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)
--
			Gleb.
