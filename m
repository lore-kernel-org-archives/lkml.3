Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaFWMNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:13:20 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33927 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaFWMNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:13:19 -0400
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Weijie Yang <weijie.yang@samsung.com>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 0/2] zram: trivial cleanup and `struct table' rename
Date: Mon, 23 Jun 2014 21:12:41 +0900
Message-Id: <1403525563-7549-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.0.0.548.ge727dec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Two trivial patches. One kill off unused define in zram
header, the other one rename `struct table'.

P.S. These two patches are against ZRAM with Weijie Yang's
"zram: remove global tb_lock with fine grain lock" being
applied. If you decided to hold on with the patch in
question I'll resend against base ZRAM.

Sergey Senozhatsky (2):
  zram: rename struct `table' to `zram_table_entry'
  zram: remove unused SECTOR_SIZE define

 drivers/block/zram/zram_drv.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
2.0.0.421.g5428530

