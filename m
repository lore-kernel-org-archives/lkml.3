Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbaIOVyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:54:38 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58821 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbaIOVyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:54:35 -0400
Date: Mon, 15 Sep 2014 14:49:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.17-rc5
Message-ID: <20140915214905.GA18749@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a few quirks
for i8042/AT keyboards and a small device tree doc fix for Atmel
Touchscreens.

Changelog:
---------

Dmitry Torokhov (1):
      Input: atkbd - do not try 'deactivate' keyboard on any LG laptops

Hans de Goede (3):
      Input: i8042 - add Fujitsu U574 to no_timeout dmi table
      Input: i8042 - add nomux quirk for Avatar AVIU-145A6
      Input: i8042 - also set the firmware id for MUXed ports

Nick Dyer (1):
      Input: atmel_mxt_ts - fix merge in DT documentation


Diffstat:
--------

 .../devicetree/bindings/input/atmel,maxtouch.txt          |  4 ----
 drivers/input/keyboard/atkbd.c                            |  8 --------
 drivers/input/serio/i8042-x86ia64io.h                     | 15 +++++++++++++++
 drivers/input/serio/i8042.c                               |  2 ++
 4 files changed, 17 insertions(+), 12 deletions(-)

-- 
Dmitry
