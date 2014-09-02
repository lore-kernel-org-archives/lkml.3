Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaIBIPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:15:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35882 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752272AbaIBIPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:15:33 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Raphael Rigo <ml-arm@syscall.eu>, Arnaud Ebalard <arno@natisbad.org>,
        Simon Boulay <simon.boulay@vitec.com>,
        Leigh Brown <leigh@solinno.co.uk>
Subject: [PATCH V2 4/4] clk: mvebu: armada-375: Fix the description of the SAR in the comment
Date: Tue,  2 Sep 2014 10:15:19 +0200
Message-Id: <1409645719-20003-5-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409645719-20003-1-git-send-email-gregory.clement@free-electrons.com>
References: <1409645719-20003-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For dealing with the code we use the SAR1 and not the SAR0. The code
was correct, and now the comments too.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/clk/mvebu/armada-375.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mvebu/armada-375.c b/drivers/clk/mvebu/armada-375.c
index c991a4d95e10..c7af2242b796 100644
--- a/drivers/clk/mvebu/armada-375.c
+++ b/drivers/clk/mvebu/armada-375.c
@@ -27,14 +27,14 @@
  * all modified at the same time, and not separately as for the Armada
  * 370 or the Armada XP SoCs.
  *
- * SAR0[21:17]   : CPU frequency    DDR frequency   L2 frequency
+ * SAR1[21:17]   : CPU frequency    DDR frequency   L2 frequency
  *		 6   =  400 MHz	    400 MHz	    200 MHz
  *		 15  =  600 MHz	    600 MHz	    300 MHz
  *		 21  =  800 MHz	    534 MHz	    400 MHz
  *		 25  = 1000 MHz	    500 MHz	    500 MHz
  *		 others reserved.
  *
- * SAR0[22]   : TCLK frequency
+ * SAR1[22]   : TCLK frequency
  *		 0 = 166 MHz
  *		 1 = 200 MHz
  */
-- 
1.9.1

