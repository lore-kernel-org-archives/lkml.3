Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3LMOM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:12:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032Ab3LMOM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:12:26 -0500
Date: Fri, 13 Dec 2013 15:12:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1312131510050.12702@pobox.suse.cz>
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



- Genius Gx Imperator Keyboard regression fix (missing break in case),
  by Ben Hutchings
- duplicate sysfs entry error fix for hid-sensor-hub driver, by Srinivas 
  Pandruvada


Thanks.

Ben Hutchings (1):
      HID: kye: Fix missing break in kye_report_fixup()

Srinivas Pandruvada (1):
      HID: hid-sensor-hub: fix duplicate sysfs entry error

 drivers/hid/hid-kye.c        |    1 +
 drivers/hid/hid-sensor-hub.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

-- 
Jiri Kosina
SUSE Labs
