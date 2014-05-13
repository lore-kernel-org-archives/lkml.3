Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761032AbaEMK7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:59:21 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64311 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760533AbaEMK7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:03 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-76-5371faf6229f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 13/16] mfd: as3711: Make of_device_id array const
Date: Tue, 13 May 2014 12:58:50 +0200
Message-id: <1399978733-13662-13-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xy7rffhUGG8ztVLB4v3Eek8XrF4YW
	978eZbS4vGsOm8XpblYHVo8PH+M87lzbw+Yx72SgR9+WVYwenzfJBbBGcdmkpOZklqUW6dsl
	cGXsefWCueAka8XLnia2BsbLLF2MHBwSAiYSezpluxg5gUwxiQv31rN1MXJxCAksZZR48Pcr
	E4TTxyRxaMl3JpAqNgFjic3Ll7CB2CICWRI/pq1mAbGZBZIk3szoYwUZKizgKPHiN1g5i4Cq
	xPp7O8BKeAU8JNomT2OGWCYncfLYZFYQmxMo/uL2WTBbSMBd4saqSSwTGHkXMDKsYhRNLU0u
	KE5KzzXSK07MLS7NS9dLzs/dxAgJm687GJceszrEKMDBqMTD68FcECzEmlhWXJl7iFGCg1lJ
	hNf9U2GwEG9KYmVValF+fFFpTmrxIUYmDk6pBsa5ky6dX+vGx/F136zdU5cvZ2XaZDFzu6+3
	nfTzPtGDyyqPv1jodDwwps1StD/iKo9U5JSMz12Tt2woOvt9XaWM0Oe59vIyr7/arDM4tmRV
	YyVj+rwdbkEffdk/sZkyx+wo49sT8zqMT6Nn4ZzJ661Sq9ynbryYavt47rZ8JS9rpm+vvQ+J
	eJxTYinOSDTUYi4qTgQAkvrd6vkBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of struct of_device_id may be be const as expected by
of_match_table field.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/mfd/as3711.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/as3711.c b/drivers/mfd/as3711.c
index ec684fcedb42..d9706ede8d39 100644
--- a/drivers/mfd/as3711.c
+++ b/drivers/mfd/as3711.c
@@ -114,7 +114,7 @@ static const struct regmap_config as3711_regmap_config = {
 };
 
 #ifdef CONFIG_OF
-static struct of_device_id as3711_of_match[] = {
+static const struct of_device_id as3711_of_match[] = {
 	{.compatible = "ams,as3711",},
 	{}
 };
-- 
1.9.1

