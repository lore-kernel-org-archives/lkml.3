Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab3BSQW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:22:26 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24154 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab3BSQWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:22:25 -0500
X-IronPort-AV: E=Sophos;i="4.84,696,1355126400"; 
   d="scan'208";a="25800983"
From: Yaniv Gardi <ygardi@codeaurora.org>
To: linux-mmc@vger.kernel.org, vgoyal@redhat.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        akpm@linux-foundation.org
Cc: linux-arm-msm@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v9 0/2] *** adding and exposing SANITIZE capability to the user space via a unique IOCTL ***
Date: Tue, 19 Feb 2013 18:22:15 +0200
Message-Id: <1361290937-7427-1-git-send-email-ygardi@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** adding and exposing SANITIZE capability to the user space via a unique IOCTL ***

Yaniv Gardi (2):
  block: ioctl support for sanitize in eMMC 4.5
  mmc: card: Adding support for sanitize in eMMC 4.5

 block/blk-core.c          |    8 +++++
 block/blk-lib.c           |   51 ++++++++++++++++++++++++++++++
 block/blk-merge.c         |    4 ++
 block/elevator.c          |    6 +++-
 block/ioctl.c             |    9 +++++
 drivers/mmc/card/block.c  |   75 +++++++++++++++++++++++++++++++-------------
 drivers/mmc/card/queue.c  |   10 +++++-
 include/linux/blk_types.h |    7 +++-
 include/linux/blkdev.h    |    6 +++
 include/linux/mmc/host.h  |    1 +
 include/uapi/linux/fs.h   |    1 +
 kernel/trace/blktrace.c   |    2 +
 12 files changed, 154 insertions(+), 26 deletions(-)

-- 
1.7.6
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
