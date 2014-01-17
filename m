Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaAQLHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 06:07:21 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:37715 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaAQLHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 06:07:16 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [RFC PATCH 0/3] add LZ4 compression support
Date: Fri, 17 Jan 2014 14:04:14 +0300
Message-Id: <1389956657-5486-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.3.493.gb139ac2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces support for LZ4 compression
(along with LZO) and adds functionality to list and change
compression algorithms, using new `compressor' device attribute.

Sergey Senozhatsky (3):
  zram: delete zram_init_device() function
  zram: introduce zram compressor operations struct
  zram: list and select compression algorithms

 Documentation/blockdev/zram.txt | 23 +++++++++---
 drivers/block/zram/Kconfig      |  2 +
 drivers/block/zram/zram_drv.c   | 83 +++++++++++++++++++++++++++++------------
 drivers/block/zram/zram_drv.h   | 10 +++++
 4 files changed, 89 insertions(+), 29 deletions(-)

-- 
1.8.5.3.493.gb139ac2

