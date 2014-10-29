Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641AbaJ2QiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:38:08 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:37090 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934439AbaJ2QiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:38:00 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 0/7] RFC DRBD updates for 3.19
Date: Wed, 29 Oct 2014 17:37:49 +0100
Message-Id: <1414600676-11203-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

these are the proposed DRBD changes for 3.19. All minor stuff
and fixes.

I will repost it in one week with the appropriate CC: stable
header set, and eventual feedback integrated.

Thanks!


Andreas Gruenbacher (2):
  drbd: Minor cleanups
  drbd: Only use drbd_msg_put_info() in drbd_nl.c

Lars Ellenberg (2):
  drbd: fix resync throttling initialization
  drbd: merge_bvec_fn: properly remap bvm->bi_bdev

Philipp Reisner (3):
  drbd: fix race between role change and handshake
  drbd: Fix state change in case of connection timeout
  drbd: Remove an useless copy of kernel_setsockopt()

 drivers/block/drbd/drbd_actlog.c   |  3 +-
 drivers/block/drbd/drbd_int.h      | 39 +++++------------------
 drivers/block/drbd/drbd_main.c     | 23 ++++----------
 drivers/block/drbd/drbd_nl.c       | 64 +++++++++++++++++---------------------
 drivers/block/drbd/drbd_receiver.c |  2 +-
 drivers/block/drbd/drbd_req.c      |  3 +-
 drivers/block/drbd/drbd_state.c    | 42 ++++++++++++++++++++-----
 drivers/block/drbd/drbd_state.h    |  5 +++
 drivers/block/drbd/drbd_worker.c   |  5 ++-
 include/linux/drbd.h               |  2 +-
 10 files changed, 90 insertions(+), 98 deletions(-)

-- 
1.9.1

