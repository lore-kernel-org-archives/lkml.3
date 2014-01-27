Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaA0OBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:01:45 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48900 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaA0OBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:01:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 27 Jan 2014 15:01:25 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post v3.13
Message-ID: <20140127150125.4c9bb5f5@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
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

  - make remote debugging over 1394 a runtime option instead of a
    buildtime option

  - extend remote debug access past the 4 GB barrier on respectively
    capable hardware

  - documentation update

The cross-tree changes in lib/ and in Documentation/ do not conflict with
anything else in linux-next AFAIK.


Lubomir Rintel (2):
      Documentation/: update FireWire debugging documentation
      firewire: ohci: Turn remote DMA support into a module parameter

Stefan Richter (1):
      firewire: Enable remote DMA above 4 GB

 Documentation/debugging-via-ohci1394.txt   | 41 +++++++++++++++++++----------------------
 Documentation/power/basic-pm-debugging.txt |  2 +-
 drivers/firewire/core-transaction.c        |  6 +++---
 drivers/firewire/core.h                    |  3 +++
 drivers/firewire/ohci.c                    | 27 ++++++++++++++++-----------
 lib/Kconfig.debug                          | 11 -----------
 6 files changed, 42 insertions(+), 48 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-====- ---= ==-==
http://arcgraph.de/sr/
