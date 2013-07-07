Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3GGItk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 04:49:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44101 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3GGIti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 04:49:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 7 Jul 2013 10:49:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post v3.10
Message-ID: <20130707104925.5e1fcf5b@stein>
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
Make struct ieee1394_device_id.driver_data actually avaliable to
1394 protocol drivers.  This is especially useful to 1394 audio drivers
for model-specific parameters and methods.

Stefan Richter (2):
      firewire: introduce fw_driver.probe and .remove methods
      firewire: remove support of fw_driver.driver.probe and .remove methods

 drivers/firewire/core-device.c      |  39 +++++++++++++++-----
 drivers/firewire/net.c              |  50 +++++++++++++-------------
 drivers/firewire/sbp2.c             |  17 ++++-----
 drivers/media/firewire/firedtv-fw.c |  19 +++++-----
 drivers/staging/fwserial/fwserial.c |  14 ++++----
 include/linux/firewire.h            |   2 ++
 sound/firewire/isight.c             |  44 +++++++++++------------
 sound/firewire/scs1x.c              |  39 ++++++++++----------
 sound/firewire/speakers.c           | 106 ++++++++++++++++++++++---------------------------------
 9 files changed, 160 insertions(+), 170 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-===-= -=== --===
http://arcgraph.de/sr/
