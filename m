Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbaDRN0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:26:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbaDRN0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:26:37 -0400
Date: Fri, 18 Apr 2014 15:26:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HID
Message-ID: <alpine.LNX.2.00.1404181526030.3265@pobox.suse.cz>
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


- fix for merge window mismerge in hid-sony, from Frank Praznik
- fix for Surface Type/Touch Cover 2 device, from Benjamin Tissoires
- quirk for ThinkPad Helix sensor hub from Stephen Chandler Paul


thanks.

----------------------------------------------------------------
Benjamin Tissoires (1):
      HID: core: do not scan constant input report

Derya (1):
      Revert "HID: microsoft: Add ID's for Surface Type/Touch Cover 2"

Frank Praznik (1):
      HID: sony: Fix cancel_work_sync mismerge

Stephen Chandler Paul (1):
      HID: sensor-hub: add sensor hub quirk for ThinkPad Helix

 drivers/hid/hid-core.c       | 5 +++--
 drivers/hid/hid-ids.h        | 5 ++---
 drivers/hid/hid-microsoft.c  | 4 ----
 drivers/hid/hid-sensor-hub.c | 7 +++++--
 drivers/hid/hid-sony.c       | 2 --
 5 files changed, 10 insertions(+), 13 deletions(-)

-- 
Jiri Kosina
SUSE Labs
