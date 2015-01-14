Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbbANRtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:49:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34865 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbbANRtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:49:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB patches
Date: Wed, 14 Jan 2015 11:48:39 -0600
Message-ID: <1421257719-13711-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.2.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Alright, 3 more fixes for v3.19-rc and my queue is finally clean.

All three fixes are rather obvious, two of them just took longer
to sort out all the stable rules details and I ended up having
to fix all that, otherwise we would miss the time frame.

Please condiser merging to your greg/usb-linus branch.

cheers

The following changes since commit 5fb694f96e7c19e66b1c55124b98812e32e3efa5:

  usb: gadget: udc: atmel: fix possible oops when unloading module (2015-01-09 18:15:11 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.19-rc6

for you to fetch changes up to 39e60635a01520e8c8ed3946a28c2b98e6a46f79:

  usb: dwc3: gadget: Stop TRB preparation after limit is reached (2015-01-14 11:29:05 -0600)

----------------------------------------------------------------
usb: fixes for v3.19-rc6

The final set of fixes for v3.19. Two of the fixes are
related to dwc3 scatter/gather implementation when we have
more requests queued than available TRBs, while the other
is a build fix for mv-usb PHY.

Signed-off-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Amit Virdi (2):
      usb: dwc3: gadget: Fix TRB preparation during SG
      usb: dwc3: gadget: Stop TRB preparation after limit is reached

Arnd Bergmann (1):
      usb: phy: mv-usb: fix usb_phy build errors

 drivers/usb/dwc3/gadget.c    | 6 ++++--
 drivers/usb/phy/phy-mv-usb.c | 5 ++---
 2 files changed, 6 insertions(+), 5 deletions(-)
