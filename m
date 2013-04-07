Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab3DGKdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 06:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933286Ab3DGKdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 06:33:18 -0400
Date: Sun, 7 Apr 2013 13:33:15 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.9-rc5
Message-ID: <20130407103315.GA21858@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive the bugfix for the regression introduced by c300aa64ddf57. 

Andrew Honig (1):
      KVM: Allow cross page reads and writes from cached translations.

 arch/x86/kvm/lapic.c      |    2 -
 arch/x86/kvm/x86.c        |   13 +++++-------
 include/linux/kvm_host.h  |    2 -
 include/linux/kvm_types.h |    1 
 virt/kvm/kvm_main.c       |   47 ++++++++++++++++++++++++++++++++++++----------
 5 files changed, 46 insertions(+), 19 deletions(-)

--
			Gleb.
