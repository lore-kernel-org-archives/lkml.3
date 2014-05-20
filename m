Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaETQaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:30:21 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:35457 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbaETQaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:30:19 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, joe@perches.com,
        auttamchandani@logicube.com, stern@rowland.harvard.edu
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 00/10] net2280: Support for PLX USB338x and cleanout code
Date: Tue, 20 May 2014 18:30:02 +0200
Message-Id: <1400603412-19406-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB 3380 is a PCI Express Gen 2 to USB 3.0 SuperSpeed Peripheral
Controller. It shares a lot functionatily with the net228x family.

This series of patches includes some resend of previous patches.

Please check the changelog for every patch. This time it has been placed
under the tear line



Ricardo Ribalda Delgado (10):
  usb: gadget: net2280: Add support for PLX USB338X
  usb: gadget: net2280: Dont use magic numbers
  usb: gadget: net2280: Use BIT() macro
  usb: gadget: net2280: Use true/false instead of 1/0
  usb: gadget: net2280: Use module_pci_driver macro
  usb: gadget: net2280: Refactor queues_show
  usb: gadget: net2280: Pass checkpacth.pl test
  usb: gadget: net2280: Code Cleanup
  usb: gadget: net2280: Use pr_* function
  usb: gadget: net2280: Use quirks instead of pci id

 drivers/usb/gadget/Kconfig   |   10 +-
 drivers/usb/gadget/net2280.c | 2752 ++++++++++++++++++++++++++++--------------
 drivers/usb/gadget/net2280.h |  285 +++--
 include/linux/usb/usb338x.h  |  199 +++
 4 files changed, 2235 insertions(+), 1011 deletions(-)
 create mode 100644 include/linux/usb/usb338x.h

-- 
2.0.0.rc2

