Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3JCMf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:35:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab3JCMf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:35:56 -0400
Date: Thu, 3 Oct 2013 15:35:53 +0300
From: Gleb Natapov <gleb@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [PULL] KVM fix for 3.12-rc4
Message-ID: <20131003123553.GG17294@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull one more KVM fix bellow

The following changes since commit 517bf8fc211d37d3aa005fb35f9ee7f1d35cb860:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2013-10-01 10:28:11 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

for you to fetch changes up to a2ac07fe292ea41296049dfdbfeed203e2467ee7:

  Fix NULL dereference in gfn_to_hva_prot() (2013-10-03 10:08:52 +0300)

----------------------------------------------------------------
Gleb Natapov (1):
      Fix NULL dereference in gfn_to_hva_prot()

 virt/kvm/kvm_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)
--
			Gleb.
