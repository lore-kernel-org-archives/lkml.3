Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbbAIOnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:43:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757247AbbAIOnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:43:14 -0500
Date: Fri, 9 Jan 2015 15:43:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HID
Message-ID: <alpine.LNX.2.00.1501091504060.15299@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive:


=====
- bounds checking fixes in logitech and roccat drivers, from Peter Wu and
  Dan Carpenter
- double-kfree fix in i2c-hid driver on bus shutdown, from Mika Westerberg
- a couple of various small driver fixes
- a few device id additions
=====

Thanks.

----------------------------------------------------------------
Benjamin Tissoires (1):
      HID: logitech-hidpp: prefix the name with "Logitech"

Dan Carpenter (1):
      HID: roccat: potential out of bounds in pyra_sysfs_write_settings()

Daniel Nicoletti (1):
      HID: Allow HID_BATTERY_STRENGTH to be enabled

Giedrius Statkevièius (1):
      HID: Add a new id 0x501a for Genius MousePen i608X

Karl Relton (1):
      HID: add battery quirk for USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO keyboard

Mika Westerberg (1):
      HID: i2c-hid: Do not free buffers in i2c_hid_stop()

Peter Wu (3):
      HID: logitech-dj: check report length
      HID: logitech-hidpp: check WTP report length
      HID: logitech-hidpp: avoid unintended fall-through

 drivers/hid/Kconfig              |  3 ++-
 drivers/hid/hid-core.c           |  1 +
 drivers/hid/hid-ids.h            |  1 +
 drivers/hid/hid-input.c          |  3 +++
 drivers/hid/hid-kye.c            |  4 ++++
 drivers/hid/hid-logitech-dj.c    | 16 +++++++++++++++-
 drivers/hid/hid-logitech-hidpp.c | 41 ++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-roccat-pyra.c    |  8 ++++++--
 drivers/hid/i2c-hid/i2c-hid.c    |  5 -----
 drivers/hid/usbhid/hid-quirks.c  |  1 +
 10 files changed, 74 insertions(+), 9 deletions(-)

-- 
Jiri Kosina
SUSE Labs
