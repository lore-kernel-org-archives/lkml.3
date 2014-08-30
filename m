Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaH3VNY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:13:24 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51521 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaH3VNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:13:21 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 00/12] lustre: continues dead code removal
Date: Sat, 30 Aug 2014 17:12:39 -0400
Message-Id: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches continues removal of unused code in
lustre client tree.

John L. Hammond (9):
  staging/lustre/obdecho: remove #if 0-ed out regions
  staging/lustre/obdclass: remove idmap.c
  staging/lustre/obdclass: remove lu_ucred.c
  staging/lustre/obdclass: remove mea.c
  staging/lustre: remove md_object.h
  staging/lustre/mgc: remove server specific handlers
  staging/lustre/obdclass: remove llog_test.ko
  staging/lustre/obdclass: remove llog_osd.c
  staging/lustre/mdc: remove obsolete llog ioctl handlers

Oleg Drokin (2):
  staging/lustre: Remove unused header libcfs_heap.h
  staging/lustre: remove unused som_attrs and hsm_attrs structures

Peng Tao (1):
  staging/lustre/obdecho: remove metadata echo client

 .../staging/lustre/include/linux/libcfs/libcfs.h   |    1 -
 .../lustre/include/linux/libcfs/libcfs_heap.h      |  200 ---
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |    1 -
 drivers/staging/lustre/lustre/fld/fld_cache.c      |    1 -
 drivers/staging/lustre/lustre/fld/fld_request.c    |    1 -
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |    1 -
 .../lustre/lustre/include/lustre/lustre_idl.h      |   37 -
 .../staging/lustre/lustre/include/lustre_idmap.h   |  104 --
 drivers/staging/lustre/lustre/include/lustre_log.h |    9 -
 drivers/staging/lustre/lustre/include/lustre_net.h |    1 -
 drivers/staging/lustre/lustre/include/md_object.h  |  899 --------------
 drivers/staging/lustre/lustre/include/obd_class.h  |    4 -
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   15 -
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |  177 ---
 drivers/staging/lustre/lustre/obdclass/Makefile    |    9 +-
 drivers/staging/lustre/lustre/obdclass/idmap.c     |  477 --------
 drivers/staging/lustre/lustre/obdclass/llog_osd.c  | 1290 --------------------
 drivers/staging/lustre/lustre/obdclass/llog_test.c | 1072 ----------------
 drivers/staging/lustre/lustre/obdclass/lu_ucred.c  |  107 --
 drivers/staging/lustre/lustre/obdclass/mea.c       |  112 --
 .../staging/lustre/lustre/obdecho/echo_client.c    | 1103 +----------------
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |   48 -
 22 files changed, 50 insertions(+), 5619 deletions(-)
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_heap.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre_idmap.h
 delete mode 100644 drivers/staging/lustre/lustre/include/md_object.h
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/idmap.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/llog_osd.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/llog_test.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/lu_ucred.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/mea.c

-- 
1.9.3

