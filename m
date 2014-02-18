Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaBRKaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:30:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbaBRKaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:30:07 -0500
Date: Tue, 18 Feb 2014 11:30:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1402181124390.1192@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive:


- fixes for several bugs in incorrect allocations of buffers by David  
  Herrmann and Benjamin Tissoires.

- support for a few new device IDs by Archana Patni, Benjamin Tissoires, 
  Huei-Horng Yo, Reyad Attiyat and Yufeng Shen


Thanks.


Archana Patni (1):
      HID: hid-sensor-hub: quirk for STM Sensor hub

Benjamin Tissoires (2):
      HID: multitouch: add FocalTech FTxxxx support
      HID: fix buffer allocations

David Herrmann (2):
      HID: Bluetooth: hidp: make sure input buffers are big enough
      HID: hyperv: make sure input buffer is big enough

Huei-Horng Yo (1):
      HID: apple: add Apple wireless keyboard 2011 JIS model support

Reyad Attiyat (1):
      HID: microsoft: Add ID's for Surface Type/Touch Cover 2

Yufeng Shen (1):
      HID: usbhid: quirk for CY-TM75 75 inch Touch Overlay

 drivers/hid/hid-apple.c         |    3 +++
 drivers/hid/hid-core.c          |    3 +++
 drivers/hid/hid-hyperv.c        |   11 ++++++++---
 drivers/hid/hid-ids.h           |    8 ++++++++
 drivers/hid/hid-input.c         |    2 +-
 drivers/hid/hid-microsoft.c     |    4 ++++
 drivers/hid/hid-multitouch.c    |    5 +++++
 drivers/hid/hid-sensor-hub.c    |    3 +++
 drivers/hid/i2c-hid/i2c-hid.c   |    2 +-
 drivers/hid/usbhid/hid-quirks.c |    1 +
 net/bluetooth/hidp/core.c       |   16 ++++++++++++++--
 net/bluetooth/hidp/hidp.h       |    4 ++++
 12 files changed, 55 insertions(+), 7 deletions(-)

-- 
Jiri Kosina
SUSE Labs
