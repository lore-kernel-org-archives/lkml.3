Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaIPLFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:05:38 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:45746 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbaIPLFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:05:36 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-mtd@lists.infradead.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie8@gmail.com>, Jiri Kosina <trivial@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v3 0/7] mtd: denali: A collection of trivial coding style fixes
Date: Tue, 16 Sep 2014 20:04:18 +0900
Message-Id: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Masahiro Yamada (7):
  mtd: denali: fix the format of comment blocks
  mtd: denali: remove unnecessary variable initializations
  mtd: denali: remove unnecessary casts
  mtd: denali: change the type of iterators to int
  mtd: denali: remove a set-but-unused variable
  mtd: denali: remove unnecessary parentheses
  mtd: denali: fix indents and other trivial things

 drivers/mtd/nand/denali.c | 558 +++++++++++++++++++++++++---------------------
 1 file changed, 301 insertions(+), 257 deletions(-)

-- 
1.9.1

