Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaADHHC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 02:07:02 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61727 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaADHHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 02:07:00 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 0/8] staging/lustre: sync with external tree
Date: Sat,  4 Jan 2014 15:06:12 +0800
Message-Id: <1388819180-31538-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Happy New Year! I hope it is long enough to start sending you new patches.

Here are the updated version of previous series. Each patch is checkpatch'ed
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
 .../lustre/lustre/include/lustre_dlm_flags.h       |   14 +++-
 drivers/staging/lustre/lustre/include/obd_class.h  |    9 ++-
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
 .../staging/lustre/lustre/obdclass/obd_config.c    |   51 ++++++++++--
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |    2 +
 18 files changed, 250 insertions(+), 150 deletions(-)

-- 
1.7.7.6

