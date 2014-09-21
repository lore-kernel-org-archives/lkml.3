Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaIUOub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 10:50:31 -0400
Received: from lists.s-osg.org ([54.187.51.154]:36964 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbaIUOu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 10:50:29 -0400
Date: Sun, 21 Sep 2014 11:50:23 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [GIT PULL for v3.17-rc6] media fixes
Message-ID: <20140921115023.06f6dba4@recife.lan>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media-v3.17-rc6

For some media bug fixes:
	- a Kconfig dependency issue;
	- Some fixes for af9033/it913x demod to be more reliable and address a
	  performance regression;
	- cx18: fix an oops on devices with tda8290 tuner;
	- two new USB IDs for af9035;
	- a couple fixes on smapp driver.

Regards,
Mauro

PS.: FYI, I'm now starting to use mchehab@osg.samsung.com e-mail address.
The old one (m.chehab@samsung.com) is still valid, but we're using the
OSG subdomain for the Samsung's Open Source Group.

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media-v3.17-rc6

for you to fetch changes up to a04646c045cab08a9e62b9be8f01ecbb0632d24e:

  [media] af9035: new IDs: add support for PCTV 78e and PCTV 79e (2014-09-04 12:24:19 -0300)

----------------------------------------------------------------
media fixes for v3.17-rc6

----------------------------------------------------------------
Antti Palosaari (2):
      [media] Kconfig: do not select SPI bus on sub-driver auto-select
      [media] af9033: feed clock to RF tuner

Bimow Chen (2):
      [media] af9033: update IT9135 tuner inittabs
      [media] it913x: init tuner on attach

Hans Verkuil (1):
      [media] cx18: fix kernel oops with tda8290 tuner

Malcolm Priestley (1):
      [media] af9035: new IDs: add support for PCTV 78e and PCTV 79e

Sakari Ailus (2):
      [media] smiapp: Fix power count handling
      [media] smiapp: Set sub-device owner

 drivers/media/Kconfig                     |  1 -
 drivers/media/dvb-core/dvb-usb-ids.h      |  2 ++
 drivers/media/dvb-frontends/af9033.c      | 13 +++++++++++++
 drivers/media/dvb-frontends/af9033_priv.h | 20 +++++++++-----------
 drivers/media/i2c/smiapp/smiapp-core.c    | 13 +++----------
 drivers/media/pci/cx18/cx18-driver.c      |  1 +
 drivers/media/tuners/tuner_it913x.c       |  6 ++++++
 drivers/media/usb/dvb-usb-v2/af9035.c     |  4 ++++
 8 files changed, 38 insertions(+), 22 deletions(-)

