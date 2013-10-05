Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3JERe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:34:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3JEReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:34:17 -0400
Date: Sat, 5 Oct 2013 10:34:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.12-rc4
Message-ID: <20131005173435.GA4872@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:

  Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.12-rc4

for you to fetch changes up to a214339d764a07b99dc0418685d6cc8a0a1970d5:

  usb: chipidea: add Intel Clovertrail pci id (2013-10-03 15:41:54 -0700)

----------------------------------------------------------------
USB fixes for 3.12-rc4

Here are 9 fixes for various USB driver problems.  The majority are
gadget/musb fixes, but there are some new device ids in here as well.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Bin Liu (2):
      usb: musb: fix otg default state
      usb: musb: gadget: fix otg active status flag

David Cohen (1):
      usb: chipidea: add Intel Clovertrail pci id

Greg Kroah-Hartman (1):
      Merge tag 'fixes-for-v3.12-rc4' of git://git.kernel.org/.../balbi/usb into usb-linus

Johan Hovold (2):
      usb: gadget: pxa25x_udc: fix deferred probe from __init
      usb: phy: gpio-vbus: fix deferred probe from __init

Michal Malý (1):
      USB: serial: option: Ignore card reader interface on Huawei E1750

Robert Baldyga (2):
      usb: gadget: f_fs: fix error handling
      usb: gadget: s3c-hsotg: fix can_write limit for non-periodic endpoints

Sebastian Andrzej Siewior (1):
      usb: musb: dsps: do not bind to "musb-hdrc"

 drivers/usb/chipidea/ci_hdrc_pci.c  |  7 ++++++-
 drivers/usb/gadget/f_fs.c           |  2 ++
 drivers/usb/gadget/pxa25x_udc.c     |  9 +++++----
 drivers/usb/gadget/s3c-hsotg.c      |  2 +-
 drivers/usb/musb/musb_dsps.c        |  3 +++
 drivers/usb/musb/musb_gadget.c      |  5 ++++-
 drivers/usb/phy/phy-gpio-vbus-usb.c | 11 +++++------
 drivers/usb/serial/option.c         |  3 +++
 8 files changed, 29 insertions(+), 13 deletions(-)
