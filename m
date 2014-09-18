Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbaIROts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:49:48 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:60445 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbaIROtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:49:46 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH 0/2] More for the 3.18 merge window
Date: Thu, 18 Sep 2014 16:49:40 +0200
Message-Id: <1411051782-23375-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

please put these two patches into your for-3.18/drivers branch.  They fix
the safety code for concurrent overlapping write detection in a DRBD
dual primary setup.

The first of those two should also go to the stable kernels, I marked it
with CC: stable@kernel.org


Lai Jiangshan (2):
  drbd: compute the end before rb_insert_augmented()
  drbd: use RB_DECLARE_CALLBACKS() to define augment callbacks

 drivers/block/drbd/drbd_interval.c | 40 ++++++--------------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

-- 
1.9.1

