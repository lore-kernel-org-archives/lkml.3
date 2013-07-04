Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab3GDMfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:35:52 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:51897 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3GDMfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:35:51 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <joe@perches.com>, <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH v2 0/5] Replace debug macro
Date: Thu, 4 Jul 2013 13:35:26 +0100
Message-ID: <1372941331-9586-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372255013.2076.4.camel@joe-AO722>
References: <1372255013.2076.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series splits earlier patch from Joe, into smaller patches.

Joe Perches (5):
  staging: ozwpan: Remove extra debug logs.
  staging: ozwpan: Replace oz_trace with oz_dbg
  staging: ozwpan: Remove old debug macro.
  staging: ozwpan: Convert macro to function.
  staging: ozwpan: Rename Kbuild to Makefile

 drivers/staging/ozwpan/Kbuild          |   18 --
 drivers/staging/ozwpan/Makefile        |   16 ++
 drivers/staging/ozwpan/ozcdev.c        |   52 +++---
 drivers/staging/ozwpan/ozconfig.h      |   26 ---
 drivers/staging/ozwpan/ozdbg.h         |   54 ++++++
 drivers/staging/ozwpan/ozeltbuf.c      |   32 ++--
 drivers/staging/ozwpan/ozhcd.c         |  296 +++++++++++++++-----------------
 drivers/staging/ozwpan/ozmain.c        |    7 +-
 drivers/staging/ozwpan/ozpd.c          |   67 ++++----
 drivers/staging/ozwpan/ozproto.c       |   60 +++----
 drivers/staging/ozwpan/ozproto.h       |    2 +-
 drivers/staging/ozwpan/oztrace.c       |   36 ----
 drivers/staging/ozwpan/oztrace.h       |   35 ----
 drivers/staging/ozwpan/ozurbparanoia.c |   14 +-
 drivers/staging/ozwpan/ozurbparanoia.h |    4 +-
 drivers/staging/ozwpan/ozusbsvc.c      |   25 +--
 drivers/staging/ozwpan/ozusbsvc1.c     |   19 +-
 17 files changed, 348 insertions(+), 415 deletions(-)
 delete mode 100644 drivers/staging/ozwpan/Kbuild
 create mode 100644 drivers/staging/ozwpan/Makefile
 delete mode 100644 drivers/staging/ozwpan/ozconfig.h
 create mode 100644 drivers/staging/ozwpan/ozdbg.h
 delete mode 100644 drivers/staging/ozwpan/oztrace.c
 delete mode 100644 drivers/staging/ozwpan/oztrace.h

-- 
1.7.9.5

