Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbaAVNgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:36:51 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55727 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbaAVNgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:36:46 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 RESEND 0/8] staging/lustre: sync with external tree
Date: Wed, 22 Jan 2014 21:36:11 +0800
Message-Id: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here are the v2 of previous series. Each patch is checkpatch'ed
and build-tested independently. Please see if it is OK to merge them.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Andreas Dilger (1):
  staging/lustre/idl: remove LASSERT/CLASSERT from lustre_idl.h

Andriy Skulysh (1):
  staging/lustre/ptlrpc: flock deadlock detection does not work

Artem Blagodarenko (2):
  staging/lustre/mgs: set_param -P option that sets value permanently
  staging/lustre/obdclass: remove extra break in class_process_config

JC Lafoucriere (1):
  staging/lustre/lustre_user.h: remove obsolete comments

John L. Hammond (1):
  staging/lustre/llite: pass correct pointer to obd_iocontrol()

Lai Siyao (2):
  staging/lustre/llite: remove ll_d_root_ops
  staging/lustre/llite: don't d_add for create only files

 .../lustre/lustre/include/lustre/lustre_idl.h      |   48 +++--------
 .../lustre/lustre/include/lustre/lustre_user.h     |    6 --
 drivers/staging/lustre/lustre/include/lustre_cfg.h |    2 +
 .../staging/lustre/lustre/include/lustre_disk.h    |    2 +
 .../lustre/lustre/include/lustre_dlm_flags.h       |   14 ++-
 drivers/staging/lustre/lustre/include/obd_class.h  |    9 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   41 ++++++++-
 drivers/staging/lustre/lustre/llite/dcache.c       |   40 ++-------
 drivers/staging/lustre/lustre/llite/dir.c          |   23 +++--
 .../staging/lustre/lustre/llite/llite_internal.h   |    5 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   20 ++---
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |    6 +-
 drivers/staging/lustre/lustre/llite/namei.c        |   33 +++----
 drivers/staging/lustre/lustre/llite/statahead.c    |    7 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |   90 +++++++++++++++++---
 .../lustre/lustre/obdclass/lprocfs_status.c        |    1 +
 .../staging/lustre/lustre/obdclass/obd_config.c    |   51 +++++++++--
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |    2 +
 18 files changed, 250 insertions(+), 150 deletions(-)

-- 
1.7.9.5

