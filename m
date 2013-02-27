Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3B0KQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:16:22 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:43503 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3B0KQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:16:20 -0500
MIME-Version: 1.0
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 27 Feb 2013 15:46:00 +0530
Message-ID: <CAO_48GG2T1owdCPdmArG0ZY_SbBk5JwSu4a9O20qGvYfEObLhA@mail.gmail.com>
Subject: [GIT PULL]: dma-buf updates for 3.9
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        linux-media@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Vetter <daniel@ffwll.ch>,
        Arnd Bergmann <arnd@arndb.de>, Dave Airlie <airlied@linux.ie>,
        Tom Gall <tom.gall@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's the 3.9 pull request for dma-buf framework updates: could you
please pull?

Thanks and best regards,
~Sumit.


The following changes since commit d895cb1af15c04c522a25c79cc429076987c089b:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2013-02-26
20:16:07 -0800)

are available in the git repository at:


  git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
tags/tag-for-linus-3.9

for you to fetch changes up to 495c10cc1c0c359871d5bef32dd173252fc17995:

  CHROMIUM: dma-buf: restore args on failure of dma_buf_mmap
(2013-02-27 15:14:02 +0530)

----------------------------------------------------------------
3.9: dma-buf updates
Refcounting implemented for vmap in core dma-buf

----------------------------------------------------------------
Daniel Vetter (1):
      dma-buf: implement vmap refcounting in the interface logic

John Sheu (1):
      CHROMIUM: dma-buf: restore args on failure of dma_buf_mmap

 Documentation/dma-buf-sharing.txt |    6 +++-
 drivers/base/dma-buf.c            |   66 ++++++++++++++++++++++++++++++-------
 include/linux/dma-buf.h           |    4 ++-
 3 files changed, 63 insertions(+), 13 deletions(-)
