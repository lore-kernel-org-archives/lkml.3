Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954Ab3GQBOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 21:14:16 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45998 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3GQBOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 21:14:15 -0400
Date: Wed, 17 Jul 2013 09:14:11 +0800
From: majianpeng <majianpeng@gmail.com>
To: tglx <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] time: silence warning in tick_nohz_init().
X-Priority: 3
X-GUID: 3EAAC756-98DB-48A8-8398-AE267352D2D9
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307170914062082590@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6H1Ep3K022587

Fix those warning message when compile:
>kernel/time/tick-sched.c: In function ¡®tick_nohz_init¡¯:
>kernel/time/tick-sched.c:346:6: warning: unused variable ¡®cpu¡¯ [-Wunused-variable]

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 kernel/time/tick-sched.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6960172..ca1d6e3 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -343,8 +343,6 @@ static int tick_nohz_init_all(void)
 
 void __init tick_nohz_init(void)
 {
-	int cpu;
-
 	if (!have_nohz_full_mask) {
 		if (tick_nohz_init_all() < 0)
 			return;
-- 
1.8.3.rc1.44.gb387c77
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
