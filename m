Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3LQGLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:11:40 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43120 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3LQGLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:11:38 -0500
X-AuditID: 9c93017e-b7c17ae000003961-32-52afeb1878e7
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 0/5] zram/zsmalloc copyright and maintainers
Date: Tue, 17 Dec 2013 15:11:58 +0900
Message-Id: <1387260723-15817-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I and Nitin discussed how to maintain zsmalloc and zram.
Nitin wanted me to maintain zram because he doesn't have enough
bandwidth to quickly handle any issues that might arise and
I have maintained zram/zsmalloc during last two years so he
will be listed as co-maintainer.

Minchan Kim (5):
  zram: remove old private project comment
  zram: add copyright
  zsmalloc: add copyright
  zram: add zram maintainers
  zsmalloc: add maintainers

 Documentation/blockdev/zram.txt |    6 ------
 MAINTAINERS                     |   16 ++++++++++++++++
 drivers/block/zram/Kconfig      |    1 -
 drivers/block/zram/zram_drv.c   |    2 +-
 drivers/block/zram/zram_drv.h   |    2 +-
 include/linux/zsmalloc.h        |    1 +
 mm/zsmalloc.c                   |    1 +
 7 files changed, 20 insertions(+), 9 deletions(-)

-- 
1.7.9.5

