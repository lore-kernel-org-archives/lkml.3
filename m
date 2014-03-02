Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaCBWLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 17:11:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaCBWLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 17:11:12 -0500
Date: Sun, 2 Mar 2014 14:11:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PULL] USB fixes for 3.14-rc5
Message-ID: <20140302221123.GA13546@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.14-rc5

for you to fetch changes up to a1227f3c1030e96ebc51d677d2f636268845c5fb:

  usb: ehci: fix deadlock when threadirqs option is used (2014-02-26 15:46:42 -0800)

----------------------------------------------------------------
USB fixes for 3.14-rc5

Here are 2 USB patches for 3.14-rc5, one a new device id, and the other
fixes a reported problem with threaded irqs and the USB EHCI driver.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Joerg Dorchain (1):
      USB: ftdi_sio: add Cressi Leonardo PID

Stanislaw Gruszka (1):
      usb: ehci: fix deadlock when threadirqs option is used

 drivers/usb/host/ehci-hcd.c       | 13 ++++++++++---
 drivers/usb/serial/ftdi_sio.c     |  2 ++
 drivers/usb/serial/ftdi_sio_ids.h |  6 ++++++
 3 files changed, 18 insertions(+), 3 deletions(-)
