Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab3KUO1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:27:16 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:64493 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab3KUO1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:27:14 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v2 0/3] staging/lustre: sync with external tree
Date: Thu, 21 Nov 2013 22:24:47 +0800
Message-Id: <1385043890-3053-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The first two patches were updated to fix checkpatch warnings.
The third patch is unchanged as I cannot reproduce the build warning even
with the specific gcc version. I am resending it in the hope that you can
point out what warning it was if it is stil there.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Amir Shehata (1):
  staging/lustre/lnet: Fix assert on empty group in selftest module

Andreas Dilger (1):
  staging/lustre/ldlm: fix resource/fid check, use DLDLMRES

JC Lafoucriere (1):
  staging/lustre/llite: Access to released file triggers a restore

 drivers/staging/lustre/lnet/selftest/console.c     |   79 ++++++++++++++------
 drivers/staging/lustre/lnet/selftest/console.h     |    6 +-
 drivers/staging/lustre/lustre/include/cl_object.h  |    6 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      |   14 ++--
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    6 ++
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |   32 +++-----
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   19 ++---
 drivers/staging/lustre/lustre/llite/file.c         |   39 +++++++++-
 .../staging/lustre/lustre/llite/llite_internal.h   |    3 +
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   36 +++++++++
 drivers/staging/lustre/lustre/llite/namei.c        |    5 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   54 +++++++++++--
 drivers/staging/lustre/lustre/lov/lov_io.c         |   15 +++-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |    9 +--
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |    4 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |   18 +++--
 17 files changed, 251 insertions(+), 96 deletions(-)

-- 
1.7.9.5

