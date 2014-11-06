Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaKFRib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:38:31 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58443 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbaKFRi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:38:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB fix for v3.18-rc4
Date: Thu, 6 Nov 2014 11:39:00 -0600
Message-ID: <1415295540-841-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.1.0.GIT
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

A single fix this time. Looks like we're in pretty good shape this time.

cheers

The following changes since commit 9b1763553a89b2a84881119eeabfccdb803bb468:

  usb: gadget: function: Fixed the return value on error path (2014-10-23 14:49:35 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.18-rc4

for you to fetch changes up to 9599815de61db104ad21bc61f5e3544d2415c6ee:

  usb: dwc2: gadget: fix enumeration issues (2014-10-28 10:40:58 -0500)

----------------------------------------------------------------
usb: fixes for v3.18-rc4

A single fix this for dwc2 this time. Because of
excessive debugging messages, dwc2 would sometimes
fail enumeration. The fix is simple, just converting
a dev_info() into dev_dbg().

Signed-off-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Marek Szyprowski (1):
      usb: dwc2: gadget: fix enumeration issues

 drivers/usb/dwc2/gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
