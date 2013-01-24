Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab3AYAVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:21:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab3AYAVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:21:00 -0500
Date: Thu, 24 Jan 2013 21:03:00 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.8-rc4
Message-ID: <20130124230300.GA18560@amt.cnet>
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


Alexander Graf (1):
      KVM: PPC: Emulate dcbf

 arch/powerpc/kvm/emulate.c |    2 ++
 1 file changed, 2 insertions(+)
