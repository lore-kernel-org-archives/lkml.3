Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab3HBGBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 02:01:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29793 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3HBGBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 02:01:03 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-1d-51fb4b1d6e12
From: Jingoo Han <jg1.han@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2] mfd: menelaus: use NULL instead of 0
Date: Fri, 02 Aug 2013 15:01:01 +0900
Message-id: <000801ce8f45$aa4dbda0$fee938e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6PRZRr65Lh9rHZQsGvBgyhUS0H2g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zA11Z79+BBpP/ylhcXniJ1eL+16OM
	Fpd3zWGzOPmnl9HidDerA6vHnWt72DzmnQz06NuyitHj8ya5AJYoLpuU1JzMstQifbsEroxl
	V08yF7zkqDh2dRpjA+MO9i5GTg4JAROJpqOb2SBsMYkL99YD2VwcQgLLGCX231/ODFP0fOlN
	VojEdEaJnYdWMkI4vxgltm+8wQhSxSagJvHly2GgsRwcIgJeErfuBIGEmQXyJK5sPQa2QVjA
	QuL1pr1gm1kEVCV6LlwGi/MKWEr8+PeIEcIWlPgx+R4LRK+WxPqdx5kgbHmJzWveQh2kILHj
	7GuwehEBPYn73UeYIWpEJPa9eAd2m4TALnaJW6v2skIsE5D4NvkQC8htEgKyEpsOQM2RlDi4
	4gbLBEaxWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIyTaJuxg
	vHfA+hBjMtD6icxSosn5wGjNK4k3NDYzsjA1MTU2Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1
	KL6oNCe1+BAjEwenVAOj3L7ft+ep7dMU3eTtEJJRZt2y5YHNvoAVy1S1zketiOx4w33o/cye
	O6U5H47+0Fpue23JrEVzKl84W+apxUt/zzlVq+fpFsAz7aVJ1fo5Gmeux4tfL/y6eIF5/M4n
	n9US14jPkQrXfrlmHn/tYm5mb/487V4/Vm6zR1bRc2rVXtlMnal/yD1SiaU4I9FQi7moOBEA
	nI/hVMwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQV1Z79+BBseWS1pcXniJ1eL+16OM
	Fpd3zWGzOPmnl9HidDerA6vHnWt72DzmnQz06NuyitHj8ya5AJaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07TBNC
	Q9x0LWAaI3R9Q4LgeowM0EDCOsaMZVdPMhe85Kg4dnUaYwPjDvYuRk4OCQETiedLb7JC2GIS
	F+6tZ+ti5OIQEpjOKLHz0EpGCOcXo8T2jTcYQarYBNQkvnw5DNTNwSEi4CVx604QSJhZIE/i
	ytZjbCC2sICFxOtNe8EWsAioSvRcuAwW5xWwlPjx7xEjhC0o8WPyPRaIXi2J9TuPM0HY8hKb
	17xlhjhIQWLH2ddg9SICehL3u48wQ9SISOx78Y5xAqPALCSjZiEZNQvJqFlIWhYwsqxiFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECI7lZ9I7GFc1WBxiFOBgVOLhfZD5K1CINbGsuDL3EKME
	B7OSCO+f2UAh3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgemmbySeENjEzMjSyMzCyMTc3PS
	hJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYDT88U7mRQJLb/2NybzH49skrz2uKBZefvlZ
	hdHaJ2+v370RcumUx6lzO5+wphpn8Hg3y21S+snyrW8y2yvpbboxl4+dNrXzcXifH9xp/oXh
	mMGD4JzWqFmmBzw0ZE6YtN7akKozq3aBPsd77z+HlmnfXaJyLdfsk/vX6OIFPdNWftlqyDjx
	yUslluKMREMt5qLiRAD39b8fKQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'mmc_callback_data' and 'vtg' are pointers.
Fix the following sparse warning:

drivers/mfd/menelaus.c:445:43: warning: Using plain integer as NULL pointer
drivers/mfd/menelaus.c:469:20: warning: Using plain integer as NULL pointer

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/menelaus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 998ce8c..e4c9339 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -442,7 +442,7 @@ void menelaus_unregister_mmc_callback(void)
 	menelaus_remove_irq_work(MENELAUS_MMC_S2D1_IRQ);
 
 	the_menelaus->mmc_callback = NULL;
-	the_menelaus->mmc_callback_data = 0;
+	the_menelaus->mmc_callback_data = NULL;
 }
 EXPORT_SYMBOL(menelaus_unregister_mmc_callback);
 
@@ -466,7 +466,7 @@ static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
 	struct i2c_client *c = the_menelaus->client;
 
 	mutex_lock(&the_menelaus->lock);
-	if (vtg == 0)
+	if (!vtg)
 		goto set_voltage;
 
 	ret = menelaus_read_reg(vtg->vtg_reg);
-- 
1.7.10.4


