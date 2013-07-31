Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954Ab3GaWyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:54:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757781Ab3GaWyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:54:19 -0400
Date: Thu, 1 Aug 2013 00:54:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1308010050560.18809@pobox.suse.cz>
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



- fix for hid-sony PS3 sixaxxis breakage from Benjamin Tissories
- fix for hidraw race condition from Yonghua Zheng
- fix/bandaid for rare device enumeration problems of Logitech Unifying 
  receivers from Nestor Lopez Casado

Benjamin Tissoires (1):
      HID: sony: fix HID mapping for PS3 sixaxis controller

Nestor Lopez Casado (2):
      HID: Revert "Revert "HID: Fix logitech-dj: missing Unifying device issue""
      HID: hid-logitech-dj: querying_devices was never set

Yonghua Zheng (1):
      HID: hidraw: fix improper mutex release

 drivers/hid/hid-logitech-dj.c |   47 +++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-logitech-dj.h |    1 +
 drivers/hid/hid-sony.c        |    3 +-
 drivers/hid/hidraw.c          |    2 +-
 4 files changed, 51 insertions(+), 2 deletions(-)

-- 
Jiri Kosina
SUSE Labs
