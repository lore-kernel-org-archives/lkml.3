Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaAOKT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:19:29 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35640 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAOKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:19:26 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv2 0/4] zram stats rework and code cleanup
Date: Wed, 15 Jan 2014 13:16:13 +0300
Message-Id: <1389780977-18949-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.3.493.gb139ac2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes zram stats clean up and enhancements.

Sergey Senozhatsky (4):
  zram: drop `init_done' struct zram member
  zram: do not pass rw argument to __zram_make_request()
  zram: rework reported to end-user zram statistics
  zram: report failed read and writes stats

 drivers/block/zram/zram_drv.c | 210 ++++++++++++++----------------------------
 drivers/block/zram/zram_drv.h |  18 ++--
 2 files changed, 74 insertions(+), 154 deletions(-)

-- 
1.8.5.3.493.gb139ac2

