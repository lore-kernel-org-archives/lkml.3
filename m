Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbaE3NmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:42:19 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55323 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190AbaE3NmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:42:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 30 May 2014 15:41:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire fixes
Message-ID: <20140530154141.75063327@kant>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-fixes" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-fixes

to receive a regression fix for the IEEE 1394 subsystem:
Re-enable IRQ-based asynchronous request reception at addresses below 128 TB.

Stefan Richter (1):
      firewire: revert to 4 GB RDMA, fix protocols using Memory Space

 Documentation/debugging-via-ohci1394.txt | 13 ++++++++-----
 drivers/firewire/core.h                  |  4 ++--
 drivers/firewire/ohci.c                  |  2 +-
 3 files changed, 11 insertions(+), 8 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-====- -=-= ====-
http://arcgraph.de/sr/
