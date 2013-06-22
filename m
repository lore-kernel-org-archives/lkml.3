Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab3FVObD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 10:31:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3FVObB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 10:31:01 -0400
Date: Sat, 22 Jun 2013 07:31:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.10-rc7
Message-ID: <20130622143144.GA10905@kroah.com>
References: <20130614163851.GA25973@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614163851.GA25973@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.10-rc6

for you to fetch changes up to 35a2fbc941accd0e9f1bfadd669311786118d874:

  USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable (2013-06-19 15:54:45 -0700)

----------------------------------------------------------------
USB fixes for 3.10-rc7

Here are two USB patches for 3.10.  One updates the Kconfig wording for
CONFIG_USB_PHY to make it, hopefully, more obvious what this option is
(I know you complained about this when it hit the tree.)  The other is a
new device id for a driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Anders Hammarquist (1):
      USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable

George Spelvin (1):
      usb: phy: Improve Kconfig help for CONFIG_USB_PHY

 drivers/usb/phy/Kconfig               | 14 ++++++++++----
 drivers/usb/serial/ti_usb_3410_5052.c |  3 ++-
 drivers/usb/serial/ti_usb_3410_5052.h |  4 +++-
 3 files changed, 15 insertions(+), 6 deletions(-)
