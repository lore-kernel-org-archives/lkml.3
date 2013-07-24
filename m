Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab3GXKYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:24:05 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:43111 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750843Ab3GXKYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:24:04 -0400
From: mail-agent-noreply@emc.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v2 0/4] staging/lustre: convert to new shrinker API
Date: Wed, 24 Jul 2013 18:18:51 +0800
Message-Id: <1374661135-17072-1-git-send-email-mail-agent-noreply@emc.com>
X-Mailer: git-send-email 1.7.1
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <bergwolf@gmail.com>

Hi Andrew,

Following patches convert Lustre to new shrinker scan/count API.
They are rebased on top of latest staging-next and can replace
the current Lustre shrinker patches in linux-next/akpm.
Please help to queue them.

Thanks,
Tao

Cc: Andreas Dilger <andreas.dilger@intel.com>

Peng Tao (4):
  staging/lustre/ldlm: convert to shrinkers to count/scan API
  staging/lustre/obdclass: convert lu_object shrinker to count/scan API
  staging/lustre/ptlrpc: convert to new shrinker API
  staging/lustre/libcfs: cleanup linux-mem.h

 .../lustre/include/linux/libcfs/linux/linux-mem.h  |   38 -----
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |  148 +++++++++++---------
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   98 +++++++------
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |   76 ++++++-----
 4 files changed, 173 insertions(+), 187 deletions(-)

