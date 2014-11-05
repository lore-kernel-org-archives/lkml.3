Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaKERkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:40:21 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:32984 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754729AbaKERkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:40:17 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 0/3] more tty closing fixes
Date: Wed,  5 Nov 2014 12:40:02 -0500
Message-Id: <1415209205-16309-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

These 3 patches are stragglers from the old tty closing series.
I'm still working on eliminating ASYNC_CLOSING and the improvements to
opening in O_NONBLOCK mode.

Regards,

Peter Hurley (3):
  tty: Move tty hung up check from port->lock critical section
  tty: Convert tty->closing to int
  tty: Flush tty buffers after hardware shutdown

 drivers/tty/tty_port.c | 7 +++----
 include/linux/tty.h    | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

-- 
2.1.3

