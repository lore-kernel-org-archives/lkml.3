Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbbAVTgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:36:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55754 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbbAVTgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:36:36 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB fixes for v3.19-rc
Date: Thu, 22 Jan 2015 13:36:33 -0600
Message-ID: <1421955393-26400-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.3.0-rc1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

two more fixes needed from my side. Let me know if you prefer
to handle them differently.

cheers

The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc:

  Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.19-rc6

for you to fetch changes up to 0df8fc37f6e4a1c25c56741c3fe82970c02b7786:

  usb: phy: never defer probe in non-OF case (2015-01-19 12:50:27 -0600)

----------------------------------------------------------------
usb: fixes for v3.19-rc6

Just two fixes pending. A fix USB PHY for non-OF case and
a fix for dwc2 running on samsung SoC.

Signed-off-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Heikki Krogerus (1):
      usb: phy: never defer probe in non-OF case

Robert Baldyga (1):
      usb: dwc2: call dwc2_is_controller_alive() under spinlock

 drivers/usb/dwc2/core_intr.c | 6 +++---
 drivers/usb/phy/phy.c        | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
