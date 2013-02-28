Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab3B1Jax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:30:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3B1Jau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:30:50 -0500
Date: Thu, 28 Feb 2013 11:30:47 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM fixe for 3.9
Message-ID: <20130228093047.GA7442@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive the following KVM bug fix.


Peter Hurley (1):
      x86/kvm: Fix pvclock vsyscall fixmap

 arch/x86/kernel/pvclock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--
			Gleb.
