Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3AaVmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:42:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab3AaVmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:42:12 -0500
Date: Thu, 31 Jan 2013 22:42:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1301312238390.23853@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-3.8/upstream-fixes

to receive updates that should still go into 3.8.


- fix i2c-hid and hidraw interaction, by Benjamin Tissoires
- a quirk to make a particular device (Formosa IR receiver) work properly,
  by Nicholas Santos


Thanks.


Benjamin Tissoires (1):
      HID: i2c-hid: fix i2c_hid_output_raw_report

Jiri Kosina (1):
      HID: remove x bit from sensor doc

Nicholas Santos (1):
      HID: usbhid: quirk for Formosa IR receiver

 drivers/hid/hid-ids.h            |    3 +++
 drivers/hid/i2c-hid/i2c-hid.c    |   13 ++++++++++++-
 drivers/hid/usbhid/hid-quirks.c  |    1 +
 3 files changed, 16 insertions(+), 1 deletions(-)
 mode change 100755 => 100644 Documentation/hid/hid-sensor.txt

-- 
Jiri Kosina
SUSE Labs
