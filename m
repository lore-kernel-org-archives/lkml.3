Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3EIMq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:46:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54957 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab3EIMq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:46:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 9 May 2013 14:46:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post v3.9
Message-ID: <20130509144642.63d71b97@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-updates" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-updates

to receive the following IEEE 1394 (FireWire) subsystem changes:
  - fix controller removal when controller is in suspended state
  - fix video reception on VIA VT6306 with gstreamer, MythTV, and maybe dv4l
  - fix a startup issue with Agere/LSI FW643-e2
  - error logging improvements and other small updates

Thanks.

Andy Leiserson (1):
      firewire: ohci: fix VIA VT6306 video reception

Paul Bolle (1):
      firewire: Remove two unneeded checks for macros

Peter Hurley (6):
      firewire: ohci: Fix double free_irq()
      firewire: ohci: Check LPS before register access on pci removal
      firewire: ohci: Fix 'failed to read phy reg' on FW643 rev8
      firewire: ohci: Alias dev_* log functions
      firewire: ohci: Improve bus reset error messages
      firewire: ohci: dump_stack() for PHY regs read/write failures

Stefan Richter (3):
      firewire: core: remove an always false test
      firewire: sbp2: replace BUG_ON by WARN_ON
      firewire: remove unnecessary alloc/OOM messages

 drivers/firewire/core-cdev.c   |  27 +++---
 drivers/firewire/core-device.c |   4 +-
 drivers/firewire/net.c         |   7 +-
 drivers/firewire/ohci.c        | 270 +++++++++++++++++++++++++++++++++---------------------------
 drivers/firewire/sbp2.c        |  10 +--
 5 files changed, 166 insertions(+), 152 deletions(-)
-- 
Stefan Richter
-=====-===-= -=-= -=--=
http://arcgraph.de/sr/
