Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbbAIX5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:57:43 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55660 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbbAIX5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:57:35 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 00/11] coresight: next 
Date: Fri,  9 Jan 2015 16:57:11 -0700
Message-Id: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Good afternoon Greg,

Please consider the following coresight-related patches for inclusion
in your tree.  The set is based on v3.19-rc3.

Thanks,
Mathieu

Dan Carpenter (1):
  coresight-etm: unlock on error paths in mode_store()

Kaixu Xia (3):
  coresight: fix typo in comment in of_coresight.c
  coresight: fix comment in of_coresight.c
  coresight: fixing validity check on remote device

Mathieu Poirier (2):
  coresight-etm: Fix initial trace ID value
  coresight: Fixing wrong #ifdef/#endif placement

Wei Yongjun (4):
  coresight-etb: use module_amba_driver to simplify the code
  coresight-funnel: use module_amba_driver to simplify the code
  coresight-tmc: use module_amba_driver to simplify the code
  coresight-tpiu: use module_amba_driver to simplify the code

Xia Kaixu (1):
  coresight: remove the unused macro CORESIGHT_DEBUGFS_ENTRY

 drivers/coresight/coresight-etb10.c  | 12 +-----------
 drivers/coresight/coresight-etm3x.c  | 16 +++++++++++++---
 drivers/coresight/coresight-funnel.c | 12 +-----------
 drivers/coresight/coresight-tmc.c    | 12 +-----------
 drivers/coresight/coresight-tpiu.c   | 12 +-----------
 drivers/coresight/of_coresight.c     |  6 +++---
 include/linux/coresight.h            | 19 +++++--------------
 7 files changed, 25 insertions(+), 64 deletions(-)

-- 
1.9.1

