Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab3J3Clq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:41:46 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38902 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3J3Clo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:41:44 -0400
Date: Wed, 30 Oct 2013 10:41:35 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 0/3] handle some bugs for REQ_NOMERGE.
X-Priority: 3
X-GUID: B1B18431-A032-421B-9BF4-CD2278797655
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <2013103010413167237212@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9U2fq7s017342

This patch set mainly handle some bugs for REQ_NOMERGE.

Jianpeng Ma (3):
  block: Add REQ_NOMERGE into REQ_COMMON_MASK
  block: Check bio can merge before call attempt_plug_merge.
  md/raid5: For stripe with R5_ReadNoMerge, we replace REQ_FLUSH with   
     REQ_NOMERGE.

 block/blk-core.c          | 2 +-
 drivers/md/raid5.c        | 2 +-
 include/linux/blk_types.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
1.8.4ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
