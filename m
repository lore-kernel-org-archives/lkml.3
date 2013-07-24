Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3GXSLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:11:22 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54277 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3GXSLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:11:19 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH-RESEND 0/3] staging/lustre: Intel tree sync and two fixups
Date: Thu, 25 Jul 2013 02:08:16 +0800
Message-Id: <1374689299-10126-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Following are the rest of previous patchset rebased on latest staging-next
and reordered to avoid breaking bisecability. Please help to queue them.

[Resend again to fix up patch authorship of my own. Sorry for the noise...]

Thanks,
Tao

Liu Xuezhao (1):
  staging/lustre/obdclass: add obd_target.h

Peng Tao (2):
  staging/lustre: fix build on non-x86
  staging/lustre: fix Kconfig bool defaults

 drivers/staging/lustre/lustre/Kconfig              |    2 +-
 .../lustre/lustre/include/linux/lustre_fsfilt.h    |   10 -
 .../staging/lustre/lustre/include/lprocfs_status.h |   36 --
 drivers/staging/lustre/lustre/include/obd.h        |  140 +----
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |    1 -
 drivers/staging/lustre/lustre/obdclass/Makefile    |    2 +-
 .../lustre/lustre/obdclass/lprocfs_jobstats.c      |  560 --------------------
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |    1 -
 drivers/staging/lustre/lustre/ptlrpc/Makefile      |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/errno.c       |    4 +-
 10 files changed, 6 insertions(+), 752 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c

-- 
1.7.9.5

