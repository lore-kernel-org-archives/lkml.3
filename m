Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbaICUdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:33:42 -0400
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:41593 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756059AbaICUdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:33:40 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 0/3] blk-mq: Minor tweaks
Date: Wed,  3 Sep 2014 22:33:04 +0200
Message-Id: <cover.1409775956.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

These are few changes to blk-mq/blk-mq-tag, nothing really serious.

Cc: Jens Axboe <axboe@kernel.dk>

Alexander Gordeev (3):
  blk-mq: Cleanup blk_mq_tag_busy() and blk_mq_tag_idle()
  blk-mq: Eliminate superfluous check of BLK_MQ_S_TAG_ACTIVE flag
  blk-mq: Fix formula to calculate fair share of tags

 block/blk-mq-tag.c |  9 +++------
 block/blk-mq-tag.h | 17 ++++++++---------
 2 files changed, 11 insertions(+), 15 deletions(-)

-- 
1.9.3

