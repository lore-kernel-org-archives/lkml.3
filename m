Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3KSOmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:42:21 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37096 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab3KSOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:16 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 00/13] staging/lustre: remove some unused code
Date: Tue, 19 Nov 2013 22:38:34 +0800
Message-Id: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas and Greg,

Following patches remove some unused files and also clean up kp.30.h a bit.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Peng Tao (13):
  staging/lustre/libcfs: remove HAVE_MM_INLINE
  staging/lustre: remove liblustreapi.h
  staging/lustre: remove lustreapi.h
  staging/lustre: remove fsfilt_ext3.c
  staging/lustre/o2iblnd: remove kib_sysctl
  staging/lustre/socklnd: remove ksnd_sysctl
  staging/lustre: remove CFS_SYSFS_MODULE_PARM
  staging/lustre/libcfs: remove IOCTL_LIBCFS_TYPE
  staging/lustre: remove __CYGWIN__
  staging/lustre: remove _LWORDSIZE
  staging/lustre: get_cpu is always defined
  staging/lustre: remove INIT_CTL_NAME
  staging/lustre: remove INIT_STRATEGY

 .../lustre/include/linux/libcfs/libcfs_ioctl.h     |   66 +-
 .../lustre/include/linux/libcfs/linux/kp30.h       |   36 +-
 drivers/staging/lustre/include/linux/lnet/types.h  |   11 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    1 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |    3 -
 .../lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c  |  262 -------
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    1 -
 .../staging/lustre/lnet/klnds/socklnd/socklnd.h    |    6 -
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.c  |  307 --------
 .../lustre/lnet/klnds/socklnd/socklnd_modparams.c  |   12 +-
 drivers/staging/lustre/lnet/lnet/router_proc.c     |   10 -
 .../lustre/lustre/include/lustre/liblustreapi.h    |   43 --
 .../lustre/lustre/include/lustre/lustreapi.h       |  310 --------
 .../lustre/lustre/libcfs/linux/linux-proc.c        |   28 +-
 drivers/staging/lustre/lustre/lvfs/fsfilt_ext3.c   |  760 --------------------
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |   23 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |    4 -
 17 files changed, 38 insertions(+), 1845 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre/liblustreapi.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre/lustreapi.h
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/fsfilt_ext3.c

-- 
1.7.9.5

