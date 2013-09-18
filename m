Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab3IRBL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 21:11:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab3IRBL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 21:11:57 -0400
Date: Tue, 17 Sep 2013 20:11:53 -0500 (CDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID for 3.12-rc2
Message-ID: <alpine.LNX.2.00.1309172007310.26647@pobox.suse.cz>
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

- fixes for CVE-2013-2897, CVE-2013-2895, CVE-2013-2897, CVE-2013-2894, 
  CVE-2013-2893, CVE-2013-2891, CVE-2013-2890, CVE-2013-2889.
  All the bugs are triggerable only by specially crafted evil-on-purpose 
  HW devices. Fixes by Kees Cook and Benjamin Tissoires.

Benjamin Tissoires (3):
      HID: validate feature and input report details
      HID: multitouch: validate indexes details
      HID: lenovo-tpkbd: fix leak if tpkbd_probe_tp fails

Kees Cook (7):
      HID: provide a helper for validating hid reports
      HID: zeroplus: validate output report details
      HID: sony: validate HID output report details
      HID: steelseries: validate output report details
      HID: LG: validate HID output report details
      HID: lenovo-tpkbd: validate output report details
      HID: logitech-dj: validate output report details

 drivers/hid/hid-core.c         |   74 +++++++++++++++++++++++++++++++++++-----
 drivers/hid/hid-input.c        |   11 +++++-
 drivers/hid/hid-lenovo-tpkbd.c |   25 ++++++++++---
 drivers/hid/hid-lg2ff.c        |   19 ++---------
 drivers/hid/hid-lg3ff.c        |   29 +++------------
 drivers/hid/hid-lg4ff.c        |   20 +----------
 drivers/hid/hid-lgff.c         |   17 +--------
 drivers/hid/hid-logitech-dj.c  |   10 ++++-
 drivers/hid/hid-multitouch.c   |   26 +++++++------
 drivers/hid/hid-sony.c         |    4 ++
 drivers/hid/hid-steelseries.c  |    5 +++
 drivers/hid/hid-zpff.c         |   18 +++-------
 include/linux/hid.h            |    4 ++
 13 files changed, 146 insertions(+), 116 deletions(-)

-- 
Jiri Kosina
SUSE Labs
