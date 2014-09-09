Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaIICDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:03:02 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:33659 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105AbaIICDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:03:00 -0400
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
Subject: [PATCH v2 0/7] mtd: denali: A collection of trivial coding style fixes
Date: Tue,  9 Sep 2014 11:01:50 +0900
Message-Id: <1410228117-14820-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Changes in v2:
  - Join quotes strings into a single line

Masahiro Yamada (7):
  mtd: denali: fix the format of comment blocks
  mtd: denali: remove unnecessary variable initializations
  mtd: denali: remove unnecessary casts
  mtd: denali: change the type of iterators to int
  mtd: denali: remove a set-but-unused variable
  mtd: denali: remove unnecessary parentheses
  mtd: denali: fix indents and other trivial things

 drivers/mtd/nand/denali.c | 562 +++++++++++++++++++++++++---------------------
 1 file changed, 303 insertions(+), 259 deletions(-)

-- 
1.9.1

