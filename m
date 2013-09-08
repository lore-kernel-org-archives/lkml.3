Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3IHQO1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 12:14:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50794 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3IHQO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 12:14:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 8 Sep 2013 18:14:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post v3.11
Message-ID: <20130908181413.62a244d6@stein>
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

  - Fix a regression since 3.2 inclusive:  The subsystem workqueue
    deadlocked between transaction completion handling and bus reset
    handling if the worker pool could not be increased in time.

  - janitorial updates

Backports of the regression fix for -stable and -longterm will be
posted after upstream merge.

Stefan Richter (3):
      firewire: core: typecast from gfp_t to bool more safely
      firewire: ohci: change confusing name of a struct member
      firewire: ohci: beautify some macro definitions

Stephan Gatzka (2):
      firewire: ohci: Change module_pci_driver to module_init/module_exit
      firewire: ohci: Fix deadlock at bus reset

Tejun Heo (1):
      firewire: WQ_NON_REENTRANT is meaningless and going away

 drivers/firewire/core-cdev.c        |  2 +-
 drivers/firewire/core-transaction.c |  3 +--
 drivers/firewire/ohci.c             | 50 ++++++++++++++++++++++++++++++++++----------------
 3 files changed, 36 insertions(+), 19 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-===-= =--= -=---
http://arcgraph.de/sr/
