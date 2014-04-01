Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaDAMyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:54:15 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:62309 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaDAMyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:54:08 -0400
From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
To: linux-kernel@vger.kernel.org
Cc: driverdev-devel@linuxdriverproject.org,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        Forest Bond <forest@alittletooquiet.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
Subject: [PATCH 0/3] staging: vt6655: style fixes
Date: Tue,  1 Apr 2014 09:52:10 -0300
Message-Id: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miscellaneous style fixes for the vt6655 driver. Should not affect
functionality at all. Also remove dead code, shrink driver size by
1203 lines.

Guido Martínez (3):
  staging: vt6655: fix DBG_PRT and PRINT_K macros
  staging: vt6655: remove dead code
  staging: vt6655: fix checkpatch bracing issues

 drivers/staging/vt6655/IEEE11h.c     |   6 -
 drivers/staging/vt6655/baseband.c    | 101 ++++-----
 drivers/staging/vt6655/bssdb.c       |   6 +-
 drivers/staging/vt6655/bssdb.h       |   2 -
 drivers/staging/vt6655/card.c        | 195 ++++++----------
 drivers/staging/vt6655/card.h        |   1 -
 drivers/staging/vt6655/channel.c     |  95 ++++----
 drivers/staging/vt6655/datarate.c    |  21 +-
 drivers/staging/vt6655/desc.h        |  47 ----
 drivers/staging/vt6655/device.h      |  10 +-
 drivers/staging/vt6655/device_main.c | 354 +++++++++--------------------
 drivers/staging/vt6655/dpc.c         | 155 ++++---------
 drivers/staging/vt6655/hostap.c      |  66 +-----
 drivers/staging/vt6655/ioctl.c       |   1 -
 drivers/staging/vt6655/ioctl.h       |   9 -
 drivers/staging/vt6655/iowpa.h       |   7 -
 drivers/staging/vt6655/iwctl.c       | 391 ++++++--------------------------
 drivers/staging/vt6655/key.c         |  55 ++---
 drivers/staging/vt6655/key.h         |   2 -
 drivers/staging/vt6655/mac.c         |  96 ++++----
 drivers/staging/vt6655/mac.h         |   1 -
 drivers/staging/vt6655/mib.c         |  95 ++++----
 drivers/staging/vt6655/mib.h         |   8 -
 drivers/staging/vt6655/michael.c     |  33 +--
 drivers/staging/vt6655/power.c       |  42 ++--
 drivers/staging/vt6655/power.h       |   3 -
 drivers/staging/vt6655/rf.c          |  69 +++---
 drivers/staging/vt6655/rxtx.c        | 329 ++++++++++-----------------
 drivers/staging/vt6655/rxtx.h        |  11 -
 drivers/staging/vt6655/tether.c      |   4 +-
 drivers/staging/vt6655/tkip.c        |   7 +-
 drivers/staging/vt6655/vntwifi.c     | 124 +++--------
 drivers/staging/vt6655/vntwifi.h     |  14 --
 drivers/staging/vt6655/wcmd.c        | 126 ++++-------
 drivers/staging/vt6655/wctl.c        |   9 +-
 drivers/staging/vt6655/wmgr.c        | 418 ++++++++++++-----------------------
 drivers/staging/vt6655/wmgr.h        |  30 ---
 drivers/staging/vt6655/wpa.c         |   9 +-
 drivers/staging/vt6655/wpa2.c        |  44 ++--
 drivers/staging/vt6655/wpactl.c      |  68 ++----
 drivers/staging/vt6655/wroute.c      |   1 -
 41 files changed, 931 insertions(+), 2134 deletions(-)

-- 
1.9.0

