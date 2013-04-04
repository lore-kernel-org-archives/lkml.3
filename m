Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab3DDJGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:06:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756934Ab3DDJGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:06:08 -0400
Date: Thu, 4 Apr 2013 11:06:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1304041102450.30938@pobox.suse.cz>
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


- Workaround for device ID conflict between Masterkit MA901 usb radio 
  device and Atmel V-USB devices, to avoid regressions from older 
  kernels, by Alexey Klimov
- fix for possible race during input device registration in magicmouse 
  driver, by Benjamin Tissoires


Alexey Klimov (2):
      HID: fix Masterkit MA901 hid quirks
      media: radio-ma901: return ENODEV in probe if usb_device doesn't match

Benjamin Tissoires (1):
      HID: magicmouse: fix race between input_register() and probe()

 drivers/hid/hid-core.c            |   13 ++++++++++++-
 drivers/hid/hid-ids.h             |    5 ++---
 drivers/hid/hid-magicmouse.c      |   29 ++++++++++++++++++++---------
 drivers/media/radio/radio-ma901.c |   11 +++++++++++
 4 files changed, 45 insertions(+), 13 deletions(-)

Thanks,

-- 
Jiri Kosina
SUSE Labs
