Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbaEGMyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:54:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932770AbaEGMyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:54:20 -0400
Date: Wed, 7 May 2014 14:54:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HID
Message-ID: <alpine.LNX.2.00.1405071451420.3969@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive

- fix a small bug in computation of report size, which might cause some
  devices (Atmel touchpad found on the Samsung Ativ 9) to reject reports
  with otherwise valid contents
- a few device-ID specific quirks/additions piggy-backing on top of it

Thanks.

----------------------------------------------------------------
Benjamin Tissoires (1):
      HID: core: fix computation of the report size

Hans de Goede (1):
      HID: add NO_INIT_REPORTS quirk for Synaptics Touch Pad V 103S

Peter F. Patel-Schneider (1):
      HID: sensor-hub: Add in quirk for sensor hub in Lenovo Ideapad Yogas

Tomas Sokorai (1):
      HID: multitouch: add support of EliteGroup 05D8 panels

 drivers/hid/hid-core.c          | 5 +++--
 drivers/hid/hid-ids.h           | 7 +++++++
 drivers/hid/hid-multitouch.c    | 5 +++++
 drivers/hid/hid-sensor-hub.c    | 3 +++
 drivers/hid/usbhid/hid-quirks.c | 1 +
 5 files changed, 19 insertions(+), 2 deletions(-)

-- 
Jiri Kosina
SUSE Labs
