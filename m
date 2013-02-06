Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3BFOpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:45:50 -0500
Received: from multi.imgtec.com ([194.200.65.239]:29832 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab3BFOpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:45:49 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/2] tty: metag_da: Add metag DA TTY driver
Date: Wed, 6 Feb 2013 14:45:00 +0000
Message-ID: <1360161902-25329-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_06_14_45_47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg: is it okay to take this into your tty tree as it depends on Jiri's
tty_flip/tty_port changes? It won't get built until the arch/metag tree
comes along and defines the METAG_DA Kconfig symbol.

This is the same metag_da driver as before, but rebased on tty-next and
omitting all arch/metag bits. Both parts have already been reviewed (and
I squashed the buffer flipping change into the first patch).

Sorry for all the resends by the way. I think I should have just aimed
for the tty tree in the first place :-) I'll know for future.

James Hogan (2):
  tty: metag_da: Add metag DA TTY driver
  tty: metag_da: avoid getting tty kref in dashtty_timer()

 drivers/tty/Kconfig    |   13 +
 drivers/tty/Makefile   |    1 +
 drivers/tty/metag_da.c |  677 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 691 insertions(+), 0 deletions(-)
 create mode 100644 drivers/tty/metag_da.c

-- 
1.7.7.6


