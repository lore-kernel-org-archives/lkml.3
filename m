Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab3CSJyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:54:44 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:64137 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab3CSJwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:52:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap8CANk0SFFbdWObgWdsb2JhbABDxSKBWxYOAQEWJiiDJIE+iCuyMZAhjw6DRwOWX5QNOw
X-IPAS-Result: Ap8CANk0SFFbdWObgWdsb2JhbABDxSKBWxYOAQEWJiiDJIE+iCuyMZAhjw6DRwOWX5QNOw
X-IronPort-AV: E=Sophos;i="4.84,870,1355094000"; 
   d="scan'208";a="18789982"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 0/9] staging/sb105x: minor fixes
Date: Tue, 19 Mar 2013 10:51:21 +0100
Message-Id: <1363686690-27090-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have been working in a batch of patches to make the driver sb105x
compile-able with latest source code base.

I have not tested the patches in real HW as I don't have it. Hopefully, I
didn't break anything.

The driver has a lot of coding style issues, lack of tty_port support, a lot
of debug information, commented-out code, etc.

I added a TODO file in the last commit, to gather some of the work to be done.

Thanks,

Sam

Samuel Iglesias Gonsalvez (9):
  staging/sb105x: coding style fixes
  staging/sb105x: rename _INLINE_ to inline
  staging/sb105x: delete debug printks
  staging/sb105x: change some printk to corresponding dev_*
  staging/sb105x: change some printk to corresponding pr_*
  staging/sb105x: coding style issues
  staging/sb105x: use tty_port
  staging/sb105x: remove BROKEN tag from Kconfig
  staging/sb105x: add TODO file

 drivers/staging/sb105x/Kconfig          |    2 +-
 drivers/staging/sb105x/TODO             |    6 +
 drivers/staging/sb105x/sb_mp_register.h |    7 +-
 drivers/staging/sb105x/sb_pci_mp.c      | 1277 ++++++++++++++-----------------
 drivers/staging/sb105x/sb_pci_mp.h      |  174 ++---
 drivers/staging/sb105x/sb_ser_core.h    |  226 +++---
 6 files changed, 783 insertions(+), 909 deletions(-)
 create mode 100644 drivers/staging/sb105x/TODO

-- 
1.7.10.4

