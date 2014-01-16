Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaAPNPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:15:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49675 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaAPNP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:15:26 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv3 0/8] zram stats rework and code cleanup
Date: Thu, 16 Jan 2014 16:12:08 +0300
Message-Id: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.3.493.gb139ac2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes zram stats clean up and enhancements.

Sergey Senozhatsky (8):
  zram: drop `init_done' struct zram member
  zram: do not pass rw argument to __zram_make_request()
  zram: remove good and bad compress stats
  zram: use atomic64_t for all zram stats
  zram: remove zram stats code duplication
  zram: report failed read and write stats
  zram: drop not used table `count' member
  zram: move zram size warning to documentation

 Documentation/blockdev/zram.txt |   5 ++
 drivers/block/zram/zram_drv.c   | 175 +++++++++++++---------------------------
 drivers/block/zram/zram_drv.h   |  10 +--
 3 files changed, 64 insertions(+), 126 deletions(-)

-- 
1.8.5.3.493.gb139ac2

