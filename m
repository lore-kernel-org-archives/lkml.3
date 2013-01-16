Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3APOMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:12:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab3APOMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:12:43 -0500
Date: Wed, 16 Jan 2013 16:12:40 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.8-rc3
Message-ID: <20130116141240.GA29965@redhat.com>
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


Christian Borntraeger (1):
      s390/kvm: Fix BUG in include/linux/kvm_host.h:745

 arch/s390/kvm/kvm-s390.c |    2 ++
 1 file changed, 2 insertions(+)

--
			Gleb.
