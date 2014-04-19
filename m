Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaDSTrH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 15:47:07 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:58808 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaDSTrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 15:47:00 -0400
From: "=?UTF-8?q?Guido=20Mart=C3=ADnez?=" <guido@vanguardiasur.com.ar>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        driverdev-devel@linuxdriverproject.org, forest@alittletooquiet.net,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <mtzguido@gmail.com>
Subject: [PATCH v3 0/2] staging: vt6655: style fixes
Date: Sat, 19 Apr 2014 16:44:58 -0300
Message-Id: <1397936700-5181-1-git-send-email-mtzguido@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396461184-13231-1-git-send-email-guido@vanguardiasur.com.ar>
References: <1396461184-13231-1-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the third and fourth v2 patches to apply cleanly on greg's
current tree.

Guido Martínez (2):
  staging: vt6655: remove dead code
  staging: vt6655: fix checkpatch bracing issues

 drivers/staging/vt6655/IEEE11h.c     |   6 -
 drivers/staging/vt6655/baseband.c    | 101 ++++-----
 drivers/staging/vt6655/bssdb.c       |   6 +-
 drivers/staging/vt6655/bssdb.h       |   2 -
 drivers/staging/vt6655/card.c        | 181 ++++++----------
 drivers/staging/vt6655/card.h        |   1 -
 drivers/staging/vt6655/channel.c     |  80 +++----
 drivers/staging/vt6655/datarate.c    |  22 +-
 drivers/staging/vt6655/desc.h        |  47 ----
 drivers/staging/vt6655/device.h      |   6 -
 drivers/staging/vt6655/device_main.c | 298 +++++++------------------
 drivers/staging/vt6655/dpc.c         | 142 ++++--------
 drivers/staging/vt6655/hostap.c      |  63 +-----
 drivers/staging/vt6655/ioctl.c       |   1 -
 drivers/staging/vt6655/ioctl.h       |   9 -
 drivers/staging/vt6655/iowpa.h       |   7 -
 drivers/staging/vt6655/iwctl.c       | 393 +++++++--------------------------
 drivers/staging/vt6655/key.c         |  55 ++---
 drivers/staging/vt6655/key.h         |   2 -
 drivers/staging/vt6655/mac.c         |  96 ++++----
 drivers/staging/vt6655/mac.h         |   1 -
 drivers/staging/vt6655/mib.c         |  81 ++++---
 drivers/staging/vt6655/mib.h         |   8 -
 drivers/staging/vt6655/michael.c     |  33 +--
 drivers/staging/vt6655/power.c       |  36 +--
 drivers/staging/vt6655/power.h       |   3 -
 drivers/staging/vt6655/rf.c          |  69 +++---
 drivers/staging/vt6655/rxtx.c        | 329 ++++++++++------------------
 drivers/staging/vt6655/rxtx.h        |  11 -
 drivers/staging/vt6655/tether.c      |   4 +-
 drivers/staging/vt6655/tkip.c        |   7 +-
 drivers/staging/vt6655/vntwifi.c     | 115 +++-------
 drivers/staging/vt6655/vntwifi.h     |  14 --
 drivers/staging/vt6655/wcmd.c        | 126 +++++------
 drivers/staging/vt6655/wctl.c        |   9 +-
 drivers/staging/vt6655/wmgr.c        | 410 ++++++++++++-----------------------
 drivers/staging/vt6655/wmgr.h        |  30 ---
 drivers/staging/vt6655/wpa.c         |   8 +-
 drivers/staging/vt6655/wpa2.c        |  41 ++--
 drivers/staging/vt6655/wpactl.c      |  65 +-----
 drivers/staging/vt6655/wroute.c      |   1 -
 41 files changed, 867 insertions(+), 2052 deletions(-)

-- 
1.9.1

