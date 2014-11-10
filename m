Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaKJUwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:52:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39611 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaKJUwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:52:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [GIT PULL] USB fixes for v3.18-rc5
Date: Mon, 10 Nov 2014 14:52:59 -0600
Message-ID: <1415652779-31904-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.1.0.GIT
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's another minor for v3.18-rc5. Please consider
merging to your usb-linus branch.

Tested with AM437x SK and testusb.

cheers

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.18-rc5

for you to fetch changes up to 520fe7633692181bb6d1560d655fbdfbb7c05aaa:

  usb: dwc3: ep0: fix for dead code (2014-11-10 14:39:44 -0600)

----------------------------------------------------------------
usb: fixes for v3.18-rc5

Just one fix here on dwc3 which fixes a minor
bug caused by a fix that went in this v3.18-rc
cycle.

The corner case is minimal as it can only be
reproduced with back-to-back Setup transfers
(without starting data or status phase) by
means of a LeCroy USB Trainer, where we can
generate USB packets any way we like.

Signed-off-by: Felipe Balbi <balbi@ti.com>

----------------------------------------------------------------
Felipe Balbi (1):
      usb: dwc3: ep0: fix for dead code

 drivers/usb/dwc3/ep0.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
