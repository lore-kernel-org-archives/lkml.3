Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbaKMUGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:06:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933146AbaKMUGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:06:15 -0500
Date: Thu, 13 Nov 2014 21:06:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HID
Message-ID: <alpine.LNX.2.00.1411132104170.4454@pobox.suse.cz>
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


- fix for oops in HID core upon repeated subdriver insertion/removal under 
  certain circumstances, by Benjamin Tissoires
- quirk for another Elan Touchscreen device, by Adel Gadllah


Thanks.

----------------------------------------------------------------
Adel Gadllah (1):
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 0103

Benjamin Tissoires (1):
      HID: core: cleanup .claimed field on disconnect

 drivers/hid/hid-core.c          | 1 +
 drivers/hid/hid-ids.h           | 1 +
 drivers/hid/usbhid/hid-quirks.c | 1 +
 3 files changed, 3 insertions(+)

-- 
Jiri Kosina
SUSE Labs
