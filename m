Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbaEEVUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:20:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbaEEVUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:20:42 -0400
Date: Mon, 5 May 2014 14:23:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB fixes for 3.15-rc5
Message-ID: <20140505212348.GA3931@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.15-rc4

for you to fetch changes up to 6ed07d45d09bc2aa60e27b845543db9972e22a38:

  USB: Nokia 5300 should be treated as unusual dev (2014-05-03 19:41:07 -0400)

----------------------------------------------------------------
USB fixes for 3.15-rc4

Here are some small fixes and device ids for 3.15-rc4.

All have been in linux-next just fine.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      USB: OHCI: fix problem with global suspend on ATI controllers

Bjørn Mork (1):
      usb: qcserial: add a number of Dell devices

Daniele Forsi (2):
      usb: storage: shuttle_usbat: fix discs being detected twice
      USB: Nokia 5300 should be treated as unusual dev

Greg Kroah-Hartman (1):
      Merge tag 'fixes-for-v3.15-rc4' of git://git.kernel.org/.../balbi/usb into usb-linus

Jean-Jacques Hiblot (1):
      usb: gadget: at91-udc: fix irq and iomem resource retrieval

Li Jun (1):
      usb: phy: fsm: update OTG HNP state transition

Nikita Yushchenko (1):
      fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6

Peter Chen (1):
      usb: phy: fsm: change "|" to "||" for condition OTG_STATE_A_WAIT_BCON at statemachine

Victor A. Santos (1):
      USB: Nokia 305 should be treated as unusual dev

 drivers/usb/gadget/at91_udc.c       | 10 ----------
 drivers/usb/host/ehci-fsl.c         |  3 ++-
 drivers/usb/host/ohci-hub.c         | 18 ++++++++++++++++++
 drivers/usb/host/ohci-pci.c         |  1 +
 drivers/usb/host/ohci.h             |  2 ++
 drivers/usb/phy/phy-fsm-usb.c       |  9 +++++----
 drivers/usb/serial/qcserial.c       | 15 +++++++++++++++
 drivers/usb/storage/shuttle_usbat.c |  2 +-
 drivers/usb/storage/unusual_devs.h  | 14 ++++++++++++++
 9 files changed, 58 insertions(+), 16 deletions(-)
