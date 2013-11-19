Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3KSN0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:26:14 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:49742 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab3KSN0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:26:13 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 0/9] staging/lustre: sync with exernal tree
Date: Tue, 19 Nov 2013 21:23:39 +0800
Message-Id: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Following patches were ported from Lustre external tree.

PATCH 4/9 was splitted into five patches to do separate things that
were done in the original single patch.

PATCh 3/9 is a cleanup patch.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Amir Shehata (5):
  staging/lustre/lnet: Fix assert on empty group in selftest module
  staging/lustre/lnet: coding style fix for lst_test_add_ioctl
  staging/lustre/lnet: remove extra space in lstcon_rpc_trans_abort
  staging/lustre/lnet: constify name argument of
    lstcon_group_find/lstcon_batch_find
  staging/lustre/lnet: coding style fix for lstcon_test_add

Andreas Dilger (1):
  staging/lustre/ldlm: fix resource/fid check, use DLDLMRES

JC Lafoucriere (1):
  staging/lustre/llite: Access to released file trigs a restore

Jinshan Xiong (1):
  staging/lustre/hsm: Implementation of exclusive open

Peng Tao (1):
  drivers/staging/lustre: indent lustre_ldlm_flags_vals

 drivers/staging/lustre/lnet/selftest/conctl.c      |   56 ++--
 drivers/staging/lustre/lnet/selftest/conrpc.c      |    2 +-
 drivers/staging/lustre/lnet/selftest/console.c     |  103 ++++--
 drivers/staging/lustre/lnet/selftest/console.h     |    6 +-
 drivers/staging/lustre/lustre/include/cl_object.h  |    6 +-
 .../lustre/lustre/include/linux/lustre_intent.h    |    2 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      |   19 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |    3 +
 .../lustre/lustre/include/lustre_dlm_flags.h       |   90 +++---
 drivers/staging/lustre/lustre/include/lustre_lib.h |   11 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    6 +
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    5 +
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |   36 +--
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   19 +-
 drivers/staging/lustre/lustre/llite/file.c         |  336 +++++++++++++++++++-
 .../staging/lustre/lustre/llite/llite_internal.h   |   14 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   36 +++
 drivers/staging/lustre/lustre/llite/namei.c        |    5 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   54 +++-
 drivers/staging/lustre/lustre/lov/lov_io.c         |   15 +-
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |    2 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |    7 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   49 +--
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |    4 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |   17 +-
 26 files changed, 699 insertions(+), 206 deletions(-)

-- 
1.7.9.5

