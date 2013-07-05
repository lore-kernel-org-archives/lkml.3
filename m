Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3GEKwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:52:12 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:18952
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757083Ab3GEKwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:52:10 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.177;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC02.kpit.com;RD:59.163.77.177.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23hbe9i1155h)
Subject: [patch v1]mfd: update DA9055 i2c device id
From: Ankur Raina <Ankur.Raina@kpitcummins.com>
To: <sameo@linux.intel.com>
CC: <broonie@kernel.org>, <axel.lin@gmail.com>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <david.chen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 5 Jul 2013 16:22:00 +0530
Message-ID: <1373021520.1601.15.camel@ankurr1-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.50.126]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DA9055 is a combination of pmic and codec.
This patch updates the DA9055 i2c device id to match the standard naming convention followed for such chips.

Signed-off-by: Ankur <Ankur.Raina@kpitcummins.com>
---
 drivers/mfd/da9055-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/da9055-i2c.c b/drivers/mfd/da9055-i2c.c
index 88f6dca..43d3df5 100644
--- a/drivers/mfd/da9055-i2c.c
+++ b/drivers/mfd/da9055-i2c.c
@@ -54,7 +54,7 @@ static int __devexit da9055_i2c_remove(struct i2c_client *i2c)
 }
 
 static struct i2c_device_id da9055_i2c_id[] = {
-	{"da9055-pmic", 0},
+	{"da9055", 0},
 	{ }
 };
 
-- 
1.7.1


