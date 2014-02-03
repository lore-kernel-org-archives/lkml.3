Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaBCQzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:55:08 -0500
Received: from sh.osrg.net ([192.16.179.4]:59542 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbaBCQzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:55:05 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-nilfs <linux-nilfs@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/4] nilfs2 updates
Date: Tue,  4 Feb 2014 01:50:40 +0900
Message-Id: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
X-Dispatcher: imput version 20100215(IM150)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Tue, 04 Feb 2014 01:55:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please queue this patchset for the next merge window.

Andreas's three patches will add a new ioctl which helps to mitigate
overheads of garbage collection of nilfs.  The original cover letter
can be seen at:

 [1] http://marc.info/?l=linux-nilfs&m=139081676816008

there the userland counterpart is not yet finished, but this kernel
patchset is ready for merge, I think.

My additional patch updates entries of nilfs2 file system in
MAINTAINERS file (independently).

Thanks in advance,
Ryusuke Konishi
--
Andreas Rohner (3):
      nilfs2: add struct nilfs_suinfo_update and flags
      nilfs2: add nilfs_sufile_set_suinfo to update segment usage
      nilfs2: implementation of NILFS_IOCTL_SET_SUINFO ioctl

Ryusuke Konishi (1):
      nilfs2: update MAINTAINERS file entries

 MAINTAINERS               |    4 +-
 fs/nilfs2/ioctl.c         |   92 +++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.c        |  131 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h        |    1 +
 include/linux/nilfs2_fs.h |   44 +++++++++++++++
 5 files changed, 270 insertions(+), 2 deletions(-)

