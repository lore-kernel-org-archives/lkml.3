Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab3IEUoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:44:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43106 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab3IEUox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:44:53 -0400
Date: Thu, 05 Sep 2013 16:44:51 -0400 (EDT)
Message-Id: <20130905.164451.670703104304287472.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Sep 2013 13:44:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mostly cleanups, and changes part of tree-wide adjustments, this code is
in deep freeze so that's pretty much what we expect these days.

Please pull, thanks a lot!

The following changes since commit a09e9a7a4b907f2dfa9bdb2b98a1828ab4b340b2:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2013-09-05 10:17:26 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide.git master

for you to fetch changes up to 64110c16e012547d5c9ab71f8afd3bab025f1103:

  ide: sgiioc4: Staticize ioc4_ide_attach_one() (2013-09-05 15:21:30 -0400)

----------------------------------------------------------------
Jingoo Han (4):
      ide: replace strict_strtol() with kstrtol()
      ide: use dev_get_platdata()
      ide: palm_bk3710: add missing __iomem annotation
      ide: sgiioc4: Staticize ioc4_ide_attach_one()

Xinghai Yu (1):
      ide-disk_proc: use macro to replace magic number

 drivers/ide/gayle.c        | 2 +-
 drivers/ide/ide-ioctls.c   | 4 ++--
 drivers/ide/ide-park.c     | 6 ++++--
 drivers/ide/ide_platform.c | 2 +-
 drivers/ide/palm_bk3710.c  | 4 ++--
 drivers/ide/sgiioc4.c      | 2 +-
 drivers/ide/tx4938ide.c    | 4 ++--
 7 files changed, 13 insertions(+), 11 deletions(-)
