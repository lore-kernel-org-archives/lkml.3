Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaIHINp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:13:45 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:51140 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaIHINn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:13:43 -0400
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
Subject: [PATCH 0/7] mtd: denali: A collection of trivial coding style fixes
Date: Mon,  8 Sep 2014 17:10:06 +0900
Message-Id: <1410163813-31783-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Masahiro Yamada (7):
  mtd: denali: fix the format of comment blocks
  mtd: denali: remove unnecessary variable initializations
  mtd: denali: remove unnecessary casts
  mtd: denali: change the type of "i" to int
  mtd: denali: remove a set-but-unused variable
  mtd: denali: remove unnecessary parentheses
  mtd: denali: fix indentations and other trivial things

 drivers/mtd/nand/denali.c | 532 +++++++++++++++++++++++++---------------------
 1 file changed, 290 insertions(+), 242 deletions(-)

-- 
1.9.1

