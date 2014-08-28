Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936403AbaH1Ii1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:38:27 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:36344 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934238AbaH1IiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:38:25 -0400
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 28 Aug 2014 14:08:04 +0530
Message-ID: <CAO_48GEbmUaANBuOuTSED2BNUx_sC43xpz_89k_NCACEezDQBg@mail.gmail.com>
Subject: [GIT PULL]: few dma-buf updates for 3.17-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Daniel Vetter <daniel@ffwll.ch>,
        Arnd Bergmann <arnd@arndb.de>, Dave Airlie <airlied@linux.ie>,
        Tom Gall <tom.gall@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The major changes for 3.17 already went via Greg-KH's tree this time
as well; this is a small pull request for dma-buf - all documentation
related.

Could you please pull?


The following changes since commit f1bd473f95e02bc382d4dae94d7f82e2a455e05d:

  Merge branch 'sec-v3.17-rc2' of
git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/linux-security
(2014-08-27 17:32:37 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sumits/dma-buf.git
tags/for-3.17-rc3

for you to fetch changes up to 1f58d9465c568eb47cab939bbc4f30ae51863295:

  dma-buf/fence: Fix one more kerneldoc warning (2014-08-28 11:59:38 +0530)

----------------------------------------------------------------
Small dma-buf pull request for 3.17-rc3

----------------------------------------------------------------
Gioh Kim (1):
      Documentation/dma-buf-sharing.txt: update API descriptions

Thierry Reding (2):
      dma-buf/fence: Fix a kerneldoc warning
      dma-buf/fence: Fix one more kerneldoc warning

 Documentation/dma-buf-sharing.txt | 14 ++++++++------
 drivers/dma-buf/fence.c           |  2 +-
 include/linux/seqno-fence.h       |  1 +
 3 files changed, 10 insertions(+), 7 deletions(-)
