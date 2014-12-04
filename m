Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbaLDO1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:27:45 -0500
Received: from lists.s-osg.org ([54.187.51.154]:39238 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155AbaLDO1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:27:44 -0500
Date: Thu, 4 Dec 2014 12:27:38 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.18] media fixes
Message-ID: <20141204122738.4e04448a@recife.lan>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.18-rc8

For a core fix and some driver fixes:
  - a regression fix at Remote Controller core affecting RC6 protocol
    handling;
  - a fix at video buffer handling at cx23885;
  - a race fix at solo6x10;
  - a fix at image selection at smiapp;
  - a fix at reported payload size on s2255drv;
  - two updates for MAINTAINERS file.

Thanks!
Mauro

-

The following changes since commit 167921cb0ff2bdbf25138dad799fec88c99ed316:

  [media] sp2: sp2_init() can be static (2014-11-03 19:08:06 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.18-rc8

for you to fetch changes up to d2a74581390d8e5ed09b12c9d4736847d918dfa6:

  [media] rc-core: fix toggle handling in the rc6 decoder (2014-11-21 15:57:47 -0200)

----------------------------------------------------------------
media fixes for v3.18-rc8

----------------------------------------------------------------
Andrey Utkin (1):
      [media] Update MAINTAINERS for solo6x10

David Härdeman (1):
      [media] rc-core: fix toggle handling in the rc6 decoder

Hans Verkuil (1):
      [media] cx23885: use sg = sg_next(sg) instead of sg++

Krzysztof Hałasa (1):
      [media] solo6x10: fix a race in IRQ handler

Mauro Carvalho Chehab (1):
      MAINTAINERS: Update mchehab's addresses

Sakari Ailus (1):
      [media] smiapp: Only some selection targets are settable

sensoray-dev (1):
      [media] s2255drv: fix payload size for JPG, MJPEG

 MAINTAINERS                                | 38 ++++++++++++++++--------------
 drivers/media/i2c/smiapp/smiapp-core.c     |  2 +-
 drivers/media/pci/cx23885/cx23885-core.c   |  6 ++---
 drivers/media/pci/solo6x10/solo6x10-core.c | 10 ++------
 drivers/media/rc/ir-rc6-decoder.c          |  2 +-
 drivers/media/usb/s2255/s2255drv.c         |  2 +-
 6 files changed, 28 insertions(+), 32 deletions(-)

