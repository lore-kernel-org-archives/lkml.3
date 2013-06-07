Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab3FGUgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 16:36:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab3FGUgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 16:36:39 -0400
Message-ID: <1370637393.3516.109.camel@ul30vt.home>
Subject: [GIT PULL] VFIO fix for v3.10-rc5
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Date: Fri, 07 Jun 2013 14:36:33 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.10-rc5

for you to fetch changes up to 9a6aa279d3d17af73a029fa40654e92f4e75e8bb:

  vfio: fix crash on rmmod (2013-06-05 08:54:16 -0600)

----------------------------------------------------------------
vfio - fix rmmod crash

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      vfio: fix crash on rmmod

 drivers/vfio/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


