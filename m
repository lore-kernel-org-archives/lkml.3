Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3GXRbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:31:08 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32839 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3GXRbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:31:06 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-V2-RESEND 0/4] staging/lustre: convert to new shrinker API
Date: Thu, 25 Jul 2013 01:26:28 +0800
Message-Id: <1374686792-3428-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Following patches convert Lustre to new shrinker scan/count API.
They are rebased on top of latest staging-next and can replace
the current Lustre shrinker patches in linux-next/akpm.
Please help to queue them.

Resend after fixing up sender email address. Greg complained about it
so I guess I shouldn't let you complain as well...
So here are the resent ones.

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
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |   76 +++++-----
 4 files changed, 173 insertions(+), 187 deletions(-)

-- 
1.7.9.5

