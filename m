Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3CKJon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:44:43 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205Ab3CKJom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:44:42 -0400
Date: Mon, 11 Mar 2013 10:44:36 +0100
From: Richard Weinberger <richard@nod.at>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] UML fixes for 3.9-rcX
Message-ID: <20130311104436.067b6483@spider.haslach.nod.at>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-linus

This update brings various fixes.
Nothing special...

In my local queue I have some more fixes which will be sent later to you.
3.9 unconverted strange UML issues. :(

--
Marco Stornelli (1):
      hostfs: fix a not needed double check

Paul Chavent (1):
      net: enable tx time stamping in the vde driver.

Richard Weinberger (2):
      um: Use tty_port_operations->destruct
      um: Use tty_port in SIGWINCH handler

Sergei Trofimovich (2):
      um: add missing declaration of 'getrlimit()' and friends
      um: fix build failure due to mess-up of sig_info protorype

 arch/um/drivers/chan.h          |  2 +-
 arch/um/drivers/chan_kern.c     |  4 ++--
 arch/um/drivers/chan_user.c     | 12 ++++++------
 arch/um/drivers/chan_user.h     |  6 +++---
 arch/um/drivers/line.c          | 42 ++++++++++++++++++++++++------------------
 arch/um/drivers/net_kern.c      |  2 ++
 arch/um/drivers/ssl.c           |  1 -
 arch/um/drivers/stdio_console.c |  1 -
 arch/um/os-Linux/signal.c       |  2 +-
 arch/um/os-Linux/start_up.c     |  2 ++
 fs/hostfs/hostfs_kern.c         |  9 +--------
 11 files changed, 42 insertions(+), 41 deletions(-)
--

Thanks,
//richard
