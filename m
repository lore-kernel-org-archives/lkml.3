Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbaFIPJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:09:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16874 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaFIPJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:09:58 -0400
Date: Mon, 9 Jun 2014 18:09:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] regulator: 88pm800: remove duplicate PM800_BUCK3 define
Message-ID: <20140609150951.GD9600@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PM800_BUCK3 define is cut and pasted twice so we can remove the
second instance.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
index 7a721d67..4e6c8c6 100644
--- a/drivers/regulator/88pm800.c
+++ b/drivers/regulator/88pm800.c
@@ -52,7 +52,6 @@
 #define PM800_BUCK1_3		(0x3F)
 #define PM800_BUCK2		(0x40)
 #define PM800_BUCK3		(0x41)
-#define PM800_BUCK3		(0x41)
 #define PM800_BUCK4		(0x42)
 #define PM800_BUCK4_1		(0x43)
 #define PM800_BUCK4_2		(0x44)
