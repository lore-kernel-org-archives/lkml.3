Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbaDBRze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:55:34 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:60996 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbaDBRzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:55:32 -0400
From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, forest@alittletooquiet.net,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        driverdev-devel@linuxdriverproject.org,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
Subject: [PATCH v2 0/4] staging: vt6655: style fixes
Date: Wed,  2 Apr 2014 14:53:00 -0300
Message-Id: <1396461184-13231-1-git-send-email-guido@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
References: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miscellaneous style fixes for the vt6655 driver. Should not affect
functionality at all. Also remove dead code and some stale comments.
Shrink driver size by 1100 lines.

Guido Martínez (4):
  staging: vt6655: fix DBG_PRT and PRINT_K macros
  staging: vt6655: remove mention of nonexistent function
    CARDbSetBasicRate
  staging: vt6655: remove dead code
  staging: vt6655: fix checkpatch bracing issues

 drivers/staging/vt6655/IEEE11h.c     |   6 -
 drivers/staging/vt6655/baseband.c    | 101 ++++-----
 drivers/staging/vt6655/bssdb.c       |   6 +-
 drivers/staging/vt6655/bssdb.h       |   2 -
 drivers/staging/vt6655/card.c        | 195 ++++++-----------
 drivers/staging/vt6655/card.h        |   1 -
 drivers/staging/vt6655/channel.c     |  80 +++----
 drivers/staging/vt6655/datarate.c    |  22 +-
 drivers/staging/vt6655/desc.h        |  47 ----
 drivers/staging/vt6655/device.h      |  19 +-
 drivers/staging/vt6655/device_main.c | 292 +++++++------------------
 drivers/staging/vt6655/dpc.c         | 137 +++---------
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
 drivers/staging/vt6655/wpactl.c      |  67 +-----
 drivers/staging/vt6655/wroute.c      |   1 -
 41 files changed, 875 insertions(+), 2062 deletions(-)

-- 
1.9.0

