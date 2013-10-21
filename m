Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3JUNkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:40:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab3JUNkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:40:10 -0400
Date: Mon, 21 Oct 2013 15:40:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1310211538000.14758@pobox.suse.cz>
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


- a partial revert of exponent parsing changes to make "Unit" exponent 
  item work properly again, by Nikolai Kondrashov
- a few new device IDs additions piggy-backing, by AceLan Kao and David 
  Herrmann


Thanks.

AceLan Kao (2):
      HID: usbhid: quirk for Synaptics Large Touchccreen
      HID: usbhid: quirk for SiS Touchscreen

David Herrmann (1):
      HID: wiimote: add LEGO-wiimote VID

Nikolai Kondrashov (1):
      HID: Fix unit exponent parsing again

 drivers/hid/hid-core.c          |   12 +++++++-----
 drivers/hid/hid-ids.h           |    6 ++++++
 drivers/hid/hid-input.c         |   13 ++++---------
 drivers/hid/hid-wiimote-core.c  |    5 ++++-
 drivers/hid/usbhid/hid-quirks.c |    3 +++
 5 files changed, 24 insertions(+), 15 deletions(-)

-- 
Jiri Kosina
SUSE Labs
