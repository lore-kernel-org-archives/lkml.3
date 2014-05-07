Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaEGIWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:22:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11609 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaEGIWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:22:38 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-a3-5369ed44c2b7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Todd Fischer'" <todd.fischer@ridgerun.com>
References: <01f001cf69cc$8dd3b320$a97b1960$%han@samsung.com>
In-reply-to: <01f001cf69cc$8dd3b320$a97b1960$%han@samsung.com>
Subject: [PATCH 2/4] mfd: tps6507x: Make of_device_id array const
Date: Wed, 07 May 2014 17:22:28 +0900
Message-id: <01f501cf69cd$7bac3810$7304a830$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pzI23B3Krz2pOTtOM+cSg7C0yRwAAMVUQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zfV2Xt5nBBsdXillcXniJ1eL+16OM
	Fpd3zWGzON3NavH60D5WB1aPO9f2sHnMOxnosX7RJTaPvi2rGD0+b5ILYI3isklJzcksSy3S
	t0vgyui+08tesJ21on3bW+YGxgMsXYycHBICJhKb3k5nhbDFJC7cW8/WxcjFISSwjFHibftB
	VpiiqzvuMUEkFjFKbL7yHcr5zSgxd0knG0gVm4CaxJcvh9lBbBEg++aeWWBFzAKzGCWuX94P
	lhASsJU4tP4ZUIKDg1PATuL57iAQU1jAUaJ1XQ1IBYuAqsSaH1/BFvMCVc+6eoURwhaU+DH5
	HtjVzAJaEut3HmeCsOUlNq95ywwyRkJAXeLRX12IC4wkpvw+CVUuIrHvxTtGkGskBG6xS8z7
	tIsNYpeAxLfJh1ggemUlNh1ghvhXUuLgihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC
	4qT0IlO94sTc4tK8dL3k/NxNjJAonbiD8f4B60OMyUDrJzJLiSbnA6M8ryTe0NjMyMLUxNTY
	yNzSjDRhJXHe9EdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYDZa/28szV/zjwuxm4avb
	1Tru7XfYnV921TAt9Ln2xgch793ZvPnYT3L9vJ9/SK6Vo/HWg7kRi17N4zmzZtKD76t5b095
	erjmlx/np8ldr/ZsEDN1d2aOdHd7dar91jSlNVV/d+/+fWTS9fvcPCLf3Ob5XNbXTnK7vqjb
	+8I64x3tqryR78Q1nZVYijMSDbWYi4oTASVsfIroAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAV2Xt5nBBm0XhCwuL7zEanH/61FG
	i8u75rBZnO5mtXh9aB+rA6vHnWt72DzmnQz0WL/oEptH35ZVjB6fN8kFsEY1MNpkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAO1WUihLzCkFCgUkFhcr
	6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZ03+llL9jOWtG+7S1zA+MBli5GTg4JAROJqzvu
	MUHYYhIX7q1n62Lk4hASWMQosfnKdyYI5zejxNwlnWwgVWwCahJfvhxmB7FFgOybe2aBFTEL
	zGKUuH55P1hCSMBW4tD6Z0AJDg5OATuJ57uDQExhAUeJ1nU1IBUsAqoSa358ZQWxeYGqZ129
	wghhC0r8mHwP7DhmAS2J9TuPM0HY8hKb17xlBhkjIaAu8eivLsQFRhJTfp+EKheR2PfiHeME
	RqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnAKeSe1gXNlg
	cYhRgINRiYfX4m1GsBBrYllxZe4hRgkOZiUR3l0XM4OFeFMSK6tSi/Lji0pzUosPMSYDPTqR
	WUo0OR+YnvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgbHC
	P69G7cGzzK1GXvf6ud+Lf1t29vDBkEzOZh3FcpvJs44q5lh9e111xWxH9rflc2dMtu7z29I4
	IWyGyp2zLzZ8P6Y2kUm72aHb4qIu1/1PS604e2b+i5y/Z8KO7e9Sbx/maP96JP6T/w2VrStv
	ct2V2HnvlIIu0xlu5/xfC1PmH2zavKpBeA+nEktxRqKhFnNRcSIA58TaZUUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions
handle it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/tps6507x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
index 3b27482..a2e1990 100644
--- a/drivers/mfd/tps6507x.c
+++ b/drivers/mfd/tps6507x.c
@@ -119,7 +119,7 @@ static const struct i2c_device_id tps6507x_i2c_id[] = {
 MODULE_DEVICE_TABLE(i2c, tps6507x_i2c_id);
 
 #ifdef CONFIG_OF
-static struct of_device_id tps6507x_of_match[] = {
+static const struct of_device_id tps6507x_of_match[] = {
 	{.compatible = "ti,tps6507x", },
 	{},
 };
-- 
1.7.10.4


