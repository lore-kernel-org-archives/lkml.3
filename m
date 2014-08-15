Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaHOFSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 01:18:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaHOFSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 01:18:42 -0400
From: Amit Shah <amit.shah@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hpa@linux.intel.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>, jgarzik@bitpay.com, duwe@lst.de,
        Amos Kong <akong@redhat.com>, ricardo.neri-calderon@linux.intel.com,
        tytso@mit.edu, herbert@gondor.apana.org.au,
        Amit Shah <amit.shah@redhat.com>
Subject: [PULL] virtio-rng: add derating factor for use by hwrng core
Date: Fri, 15 Aug 2014 10:46:35 +0530
Message-Id: <cover.1408078439.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sending directly to you with the commit log changes Ted Ts'o pointed
out.  Not sure if Rusty's back after his travel, but this already has
his s-o-b.

Please pull.

The following changes since commit c9d26423e56ce1ab4d786f92aebecf859d419293:

  Merge tag 'pm+acpi-3.17-rc1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2014-08-14 18:13:46 -0600)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/amit/virtio.git rng-queue

for you to fetch changes up to 34679ec7a0c45da8161507e1f2e1f72749dfd85c:

  virtio: rng: add derating factor for use by hwrng core (2014-08-15 10:26:01 +0530)

----------------------------------------------------------------

Amit Shah (1):
  virtio: rng: add derating factor for use by hwrng core

 drivers/char/hw_random/virtio-rng.c | 1 +
 1 file changed, 1 insertion(+)

-- 
1.9.3

