Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbaGZIs0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 04:48:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35946 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaGZIsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 04:48:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Jul 2014 10:48:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire regression fix
Message-ID: <20140726104809.504aa527@kant>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-fix-vt6315" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-fix-vt6315

to receive an IEEE 1394 (FireWire) subsystem fix:  MSI don't work on
VIA PCIe controllers with some isochronous workloads (regression since
v3.16-rc1).

Stefan Richter (1):
      firewire: ohci: disable MSI for VIA VT6315 again

 drivers/firewire/ohci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Thank you,
-- 
Stefan Richter
-=====-====- -=== ==-=-
http://arcgraph.de/sr/
