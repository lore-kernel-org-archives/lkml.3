Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941AbaFCVIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:08:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35523 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbaFCVIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:08:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 3 Jun 2014 23:08:00 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post v3.15
Message-ID: <20140603230800.03d32ca4@kant>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
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
One optimization for some VIA controllers, one fix, one kconfig brushup.

Daeseok Youn (1):
      firewire: net: fix NULL derefencing in fwnet_probe()

Jean Delvare (1):
      firewire: Use COMPILE_TEST for build testing

Stefan Richter (1):
      firewire: ohci: enable MSI for VIA VT6315 rev 1, drop cycle timer quirk

 drivers/firewire/Kconfig | 2 +-
 drivers/firewire/net.c   | 4 ++--
 drivers/firewire/ohci.c  | 7 +++++++
 3 files changed, 10 insertions(+), 3 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-====- -==- ---==
http://arcgraph.de/sr/
