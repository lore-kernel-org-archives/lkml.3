Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab3CVLaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:30:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab3CVLaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:30:24 -0400
Date: Fri, 22 Mar 2013 08:29:17 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.9-rc3
Message-ID: <20130322112917.GA1081@amt.cnet>
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

To fix compilation on PPC with !CONFIG_KVM


Marcelo Tosatti (1):
      Revert "KVM: allow host header to be included even for !CONFIG_KVM"

 include/linux/kvm_host.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)
