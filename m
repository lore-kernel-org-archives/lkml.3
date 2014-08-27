Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaH0HXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:23:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaH0HXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:23:18 -0400
Date: Wed, 27 Aug 2014 09:23:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HID
Message-ID: <alpine.LNX.2.00.1408270920230.2992@pobox.suse.cz>
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


- fixes for potential memory corruption problems in magicmouse and picolcd 
  drivers (the HW would have to be manufactured to be deliberately evil to 
  trigger those) which were found by Steven Vittitoe

- fix for false error message appearing in dmesg from logitech-dj driver, 
  from Benjamin Tissoires



Thanks.

----------------------------------------------------------------
Benjamin Tissoires (1):
      HID: logitech-dj: prevent false errors to be shown

Jiri Kosina (2):
      HID: magicmouse: sanity check report size in raw_event() callback
      HID: picolcd: sanity check report size in raw_event() callback

 drivers/hid/hid-logitech-dj.c  | 43 ++++++++++++++++++++++++------------------
 drivers/hid/hid-logitech-dj.h  |  1 +
 drivers/hid/hid-magicmouse.c   | 10 ++++++++++
 drivers/hid/hid-picolcd_core.c |  6 ++++++
 4 files changed, 42 insertions(+), 18 deletions(-)

-- 
Jiri Kosina
SUSE Labs
