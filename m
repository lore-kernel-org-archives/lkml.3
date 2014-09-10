Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaIJASv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 20:18:51 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:6145 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaIJASu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 20:18:50 -0400
Subject: [PATCH 0/2] block: rq_affinity default and reserved tag limits
To: axboe@kernel.dk, elliott@hp.com, hch@lst.de, linux-kernel@vger.kernel.org
From: Robert Elliott <elliott@hp.com>
Date: Tue, 09 Sep 2014 19:17:55 -0500
Message-ID: <20140910001417.9294.40414.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series changes the default blk-mq rq_affinity
to handling completions on the submitting CPU, and handles
requests for too many reserved tags.

---

Robert Elliott (2):
      block: default to rq_affinity=2 for blk-mq
      block: return error if too many reserved tags are requested


 block/blk-mq.c         |    8 +++++---
 include/linux/blkdev.h |    3 ++-
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
Robert Elliott, HP Server Storage
