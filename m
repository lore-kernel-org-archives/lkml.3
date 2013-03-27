Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3C0REe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:04:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab3C0REd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:04:33 -0400
Date: Wed, 27 Mar 2013 18:04:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1303271757430.23442@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the following:



- fix for potential 3.9 regression in handling of buttons for touchpads 
  following HID mt specification; potential because reportedly there is
  no retail product on the market that would be using this feature, but 
  nevertheless we'd better follow the spec. Fix by Benjamin Tissoires.
- support for two quirky devices added by Josh Boyer.




Benjamin Tissoires (1):
      HID: multitouch: fix touchpad buttons

Jiri Kosina (1):
      HID: usbhid: fix build problem

Josh Boyer (2):
      HID: usbhid: quirk for Realtek Multi-card reader
      HID: usbhid: quirk for MSI GX680R led panel

 drivers/hid/hid-ids.h           |    6 ++++++
 drivers/hid/hid-multitouch.c    |    6 +++++-
 drivers/hid/usbhid/hid-quirks.c |    2 ++
 3 files changed, 13 insertions(+), 1 deletions(-)

Thanks,

-- 
Jiri Kosina
SUSE Labs
