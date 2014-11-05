Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaKER0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:26:55 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:45170 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755576AbaKER0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:26:53 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 0/9] various tty cleanups
Date: Wed,  5 Nov 2014 12:26:23 -0500
Message-Id: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

These patches are a mixture of dead declaration removals, uapi cleanup,
and other miscellany.

This series depends on the 10-patch 'serial core fixes' series.

Regards,

Peter Hurley (9):
  tty: Replace open-coded test with tty_hung_up_p()
  tty: Call methods in modern style
  tty: Remove defunct pcxe_open() declaration
  tty: Remove defunct serial_console_init() declaration
  serial: hp300: Remove obsolete comments
  cris: Remove obsolete ASYNC_SPLIT_TERMIOS behavior
  tty: Document defunct ASYNC_SPLIT_TERMIOS flag in uapi header
  vt: Remove vt_get_kmsg_redirect() from uapi header
  serial: 8250_em: Remove out-of-memory message

 drivers/tty/serial/8250/8250_em.c    |  4 +---
 drivers/tty/serial/8250/8250_hp300.c |  4 ----
 drivers/tty/serial/crisv10.c         | 12 ------------
 drivers/tty/serial/crisv10.h         |  1 -
 drivers/tty/tty_io.c                 | 14 +++++++-------
 drivers/tty/tty_ioctl.c              |  4 ++--
 drivers/tty/vt/vt.c                  |  2 ++
 include/linux/tty.h                  |  8 --------
 include/uapi/linux/tty_flags.h       |  2 +-
 include/uapi/linux/vt.h              |  3 ---
 10 files changed, 13 insertions(+), 41 deletions(-)

-- 
2.1.3

