Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab3LIO7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:59:50 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:35174 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab3LIO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:59:49 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 00/13] staging/lustre: sync with external tree, set 3
Date: Mon,  9 Dec 2013 22:56:52 +0800
Message-Id: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The first patch is a cleanup. The rest were ported from external tree.
Please see if they can be merged.

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

Doug Oucharek (1):
  staging/lustre/lnet: Add LNet Router Priority parameter

JC Lafoucriere (2):
  staging/lustre/api: HSM import uses new released pattern
  staging/lustre/lustre_user.h: remove obsolete comments

John L. Hammond (1):
  staging/lustre/llite: pass correct pointer to obd_iocontrol()

Lai Siyao (2):
  staging/lustre/llite: remove ll_d_root_ops
  staging/lustre/llite: don't d_add for create only files

Mikhail Pershin (2):
  staging/lustre/target: move OUT to the unified target code
  staging/lustre/seq: remove seq_{query,handle}

Peng Tao (1):
  staging/lustre: remove server macros from lustre_net.h

 .../lustre/include/linux/libcfs/libcfs_ioctl.h     |    1 +
 .../staging/lustre/include/linux/lnet/lib-lnet.h   |    5 +-
 .../staging/lustre/include/linux/lnet/lib-types.h  |    2 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |    5 +-
 drivers/staging/lustre/lnet/lnet/config.c          |   39 +++-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |    6 +
 drivers/staging/lustre/lnet/lnet/router.c          |   19 +-
 drivers/staging/lustre/lnet/lnet/router_proc.c     |   16 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      |   48 +---
 .../lustre/lustre/include/lustre/lustre_user.h     |   23 +-
 drivers/staging/lustre/lustre/include/lustre_cfg.h |    2 +
 .../staging/lustre/lustre/include/lustre_disk.h    |    2 +
 .../lustre/lustre/include/lustre_dlm_flags.h       |   14 +-
 drivers/staging/lustre/lustre/include/lustre_fid.h |    6 -
 drivers/staging/lustre/lustre/include/lustre_net.h |  234 --------------------
 drivers/staging/lustre/lustre/include/obd_class.h  |    9 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   41 +++-
 drivers/staging/lustre/lustre/llite/dcache.c       |   41 +---
 drivers/staging/lustre/lustre/llite/dir.c          |   23 +-
 drivers/staging/lustre/lustre/llite/file.c         |  118 ++++++++--
 .../staging/lustre/lustre/llite/llite_internal.h   |    7 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   44 ++--
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |    6 +-
 drivers/staging/lustre/lustre/llite/namei.c        |   33 ++-
 drivers/staging/lustre/lustre/llite/statahead.c    |    7 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   32 +--
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |   90 ++++++--
 .../lustre/lustre/obdclass/lprocfs_status.c        |    1 +
 .../staging/lustre/lustre/obdclass/obd_config.c    |   51 ++++-
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |   60 +++++
 30 files changed, 511 insertions(+), 474 deletions(-)

-- 
1.7.9.5

