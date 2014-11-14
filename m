Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422769AbaKNW0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:26:46 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:63148 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161920AbaKNW0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:26:45 -0500
Date: Fri, 14 Nov 2014 14:26:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: [git pull] Input updates for 3.18-rc4
Message-ID: <20141114222640.GA39748@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Mostly small fixups to PS/2
tochpad drivers (ALPS, Elantech, Synaptics) to better deal with specific
hardware.

Changelog:
---------

NeilBrown (1):
      Input: twl4030-pwrbutton - ensure a wakeup event is recorded.

Pali Rohár (3):
      Input: alps - ignore potential bare packets when device is out of sync
      Input: alps - allow up to 2 invalid packets without resetting device
      Input: alps - ignore bad data on Dell Latitudes E6440 and E7440

Takashi Iwai (1):
      Input: synaptics - add min/max quirk for Lenovo T440s

Ulrik De Bie (5):
      Input: elantech - use elantech_report_trackpoint for hardware v4 too
      Input: elantech - fix crc_enabled for Fujitsu H730
      Input: elantech - report the middle button of the touchpad
      Input: elantech - provide a sysfs knob for crc_enabled
      Input: elantech - update the documentation


Diffstat:
--------

 Documentation/input/elantech.txt       | 81 +++++++++++++++++++++++++++++++---
 drivers/input/misc/twl4030-pwrbutton.c |  1 +
 drivers/input/mouse/alps.c             | 28 +++++++++++-
 drivers/input/mouse/elantech.c         | 56 +++++++++++++++++++++--
 drivers/input/mouse/synaptics.c        |  5 ++-
 5 files changed, 158 insertions(+), 13 deletions(-)

-- 
Dmitry

