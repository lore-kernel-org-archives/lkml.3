Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbaLORmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:42:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57242 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaLORmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:42:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 15 Dec 2014 18:42:31 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire (IEEE 1394) updates post v3.18
Message-ID: <20141215184231.5b006cab@kant>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-updates" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-updates

to receive the following IEEE 1394 subsystem updates:
Clean up firewire-ohci's longlived vm-mapping;
use target instance lock instead of core lock in firewire-sbp2.

Clemens Ladisch (1):
      firewire: ohci: replace vm_map_ram() with vmap()

Stefan Richter (4):
      firewire: core: document fw_csr_string's truncation of long strings
      firewire: sbp2: protect a reference counter properly
      firewire: sbp2: replace some spin_lock_irqsave by spin_lock_irq
      firewire: sbp2: replace card lock by target lock

 drivers/firewire/core-device.c |  3 +++
 drivers/firewire/ohci.c        |  6 ++----
 drivers/firewire/sbp2.c        | 67 ++++++++++++++++++++++++++++++-------------------------------------
 3 files changed, 35 insertions(+), 41 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-====- ==-- -====
http://arcgraph.de/sr/
