Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbbARIYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 03:24:22 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36952 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbbARIYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 03:24:18 -0500
Date: Sun, 18 Jan 2015 00:24:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: [git pull] Input updates for 3.19-rc4
Message-ID: <20150118082413.GB15720@dtor-ws>
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

to receive updates for the input subsystem.

Changelog:
---------

Dmitry Torokhov (2):
      MAINTAINERS: remove Dmitry Torokhov's alternate address
      Input: I8042 - add Acer Aspire 7738 to the nomux list

Gabriel Laskar (1):
      Input: uinput - fix ioctl nr overflow for UI_GET_SYSNAME/VERSION

Sam hung (1):
      Input: elantech - support new ICs types for version 4

Srihari Vijayaraghavan (1):
      Input: i8042 - reset keyboard to fix Elantech touchpad detection


Diffstat:
--------

 Documentation/kernel-parameters.txt   |  1 +
 MAINTAINERS                           |  1 -
 drivers/input/mouse/elantech.c        |  2 ++
 drivers/input/serio/i8042-x86ia64io.h | 39 +++++++++++++++++++++++++++++++++++
 drivers/input/serio/i8042.c           | 14 +++++++++++++
 include/uapi/linux/uinput.h           |  4 ++--
 6 files changed, 58 insertions(+), 3 deletions(-)

-- 
Dmitry

