Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3HYSWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 14:22:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab3HYSWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 14:22:35 -0400
Date: Sun, 25 Aug 2013 11:24:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 3.11-rc7
Message-ID: <20130825182446.GA18034@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305fb:

  Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.11-rc7

for you to fetch changes up to 52d5b9aba1f5790ca3231c262979c2c3e26dd99b:

  usb: phy: fix build breakage (2013-08-23 10:41:46 -0700)

----------------------------------------------------------------
USB fixes for 3.11-rc7

Here are two USB fixes for 3.11-rc7

One fixes a reported regression in the OHCI driver, and the other fixes
a reported build breakage in the USB phy drivers.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      USB: OHCI: add missing PCI PM callbacks to ohci-pci.c

Anatolij Gustschin (1):
      usb: phy: fix build breakage

 drivers/usb/host/ohci-pci.c   | 5 +++++
 drivers/usb/phy/phy-fsl-usb.h | 2 +-
 drivers/usb/phy/phy-fsm-usb.c | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)
