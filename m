Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaFLPEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:04:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbaFLPEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:04:30 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Ming Lei <tom.leiming@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 0/3] blk-mq: bitmap tag: Fix few races
Date: Thu, 12 Jun 2014 17:05:35 +0200
Message-Id: <cover.1402582256.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

This series is against for-3.16/blk-mq-tagging branch.

Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>

Alexander Gordeev (3):
  blk-mq: bitmap tag: fix races on shared ::wake_index fields
  blk-mq: bitmap tag: fix race on blk_mq_bitmap_tags::wake_cnt
  blk-mq: bitmap tag: clean-up bt_get() function

 block/blk-mq-tag.c     |   73 ++++++++++++++++++++++++++---------------------
 block/blk-mq-tag.h     |    2 +-
 include/linux/blk-mq.h |    2 +-
 3 files changed, 42 insertions(+), 35 deletions(-)

-- 
1.7.7.6

