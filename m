Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaIKWC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:02:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34034 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaIKWC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:02:26 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB fixes for v3.17-rc4
Date: Thu, 11 Sep 2014 17:02:10 -0500
Message-ID: <1410472930-25276-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's another set of fixes for v3.17. By the looks of things, I suppose
this is my last pull request for v3.17. I should have my v3.18 pull
ready by end of next week.

Let me know if you need anything to be changed.

cheers

The following changes since commit 9ce9ec95fb9b82e09b55a52f1bb8a362bf8f74d8:

  usb: phy: tegra: Avoid use of sizeof(void) (2014-09-03 09:16:01 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.17-rc4

for you to fetch changes up to 0b93a4c838fa10370d72f86fe712426ac63804de:

  usb: dwc3: fix TRB completion when multiple TRBs are started (2014-09-05 09:16:55 -0500)

----------------------------------------------------------------
usb: fixes for v3.17-rc4

Some late fixes for dwc3 so we have something more stable
on v3.17-final.

Most bugs have been there for quite a while and nobody
noticed, except for TRB completion when multiple TRBs
are started.

Patches were tested on AM437x SK and J6 EVM and are passing
my tests.

Signed-of-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Felipe Balbi (4):
      usb: dwc3: core: fix order of PM runtime calls
      usb: dwc3: core: fix ordering for PHY suspend
      usb: dwc3: omap: fix ordering for runtime pm calls
      usb: dwc3: fix TRB completion when multiple TRBs are started

Zhuang Jin Can (1):
      usb: dwc3: gadget: Fix desc NULL pointer in dwc3_gadget_ep_queue()

 drivers/usb/dwc3/core.c      | 13 +++++++------
 drivers/usb/dwc3/dwc3-omap.c |  2 +-
 drivers/usb/dwc3/gadget.c    | 11 +++--------
 3 files changed, 11 insertions(+), 15 deletions(-)
