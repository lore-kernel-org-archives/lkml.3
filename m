Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaEGIYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:24:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62516 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaEGIYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:24:07 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-21-5369eda5cf32
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Ben Dooks'" <ben.dooks@codethink.co.uk>
References: <01f001cf69cc$8dd3b320$a97b1960$%han@samsung.com>
In-reply-to: <01f001cf69cc$8dd3b320$a97b1960$%han@samsung.com>
Subject: [PATCH 4/4] mfd: sm501: Make of_device_id array const
Date: Wed, 07 May 2014 17:24:05 +0900
Message-id: <01f701cf69cd$b5ca4d20$215ee760$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pzI23B3Krz2pOTtOM+cSg7C0yRwAAQv5A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zQ92lbzODDXbON7F4cKuVyeLywkus
	Fve/HmW0uLxrDpvF6W5WB1aPZy8nM3ncubaHzWPeyUCPvi2rGD0+b5ILYI3isklJzcksSy3S
	t0vgyrj84hZjwQTWitMrLrI2ME5n6WLk5JAQMJG42DKfEcIWk7hwbz1bFyMXh5DAMkaJ+2t7
	gRwOsKInm40g4tMZJU7/uMgG0iAk8JtRYvrqGBCbTUBN4suXw+wgtgiQfXPPLCaQBmaQhnW3
	L7BCNNhKHFr/jAlkKKeAncTz3UEgYWEgc8KO/8wgNouAqsSr1U/B9vIClf+ZUwwS5hUQlPgx
	+R7YzcwCWhLrdx5ngrDlJTavecsMcaa6xKO/uiCmiICRROspPYgKEYl9L94xghwjIXCLXeLi
	jlXsEJsEJL5NPsQC0SorsekAMyQUJCUOrrjBMoFRYhaSxbOQLJ6FZPEsJCsWMLKsYhRNLUgu
	KE5KLzLRK07MLS7NS9dLzs/dxAiJzwk7GO8dsD7EmAy0fiKzlGhyPjC+80riDY3NjCxMTUyN
	jcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBsbHs6ZIfClF20gsbNj2X
	fsS9cs7KS3ddZOXCfKU4dmTP4D7zSOLj7LgVKpwndqvlRHldfNMtu25q+oxEVl1GI4a6rWvm
	VR+b9fyhVMnvHSducPw42vKOPfF94PzMSqf5twPlMlQ9f9zfZjXD2/3sjG+zjnXd2N16v1Bg
	4uVrG08wbMr0XVBi6aHEUpyRaKjFXFScCACn0OCk5QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd2lbzODDQ7vN7B4cKuVyeLywkus
	Fve/HmW0uLxrDpvF6W5WB1aPZy8nM3ncubaHzWPeyUCPvi2rGD0+b5ILYI1qYLTJSE1MSS1S
	SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
	0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8y4/OIWY8EE1orTKy6yNjBOZ+li5OCQEDCReLLZ
	qIuRE8gUk7hwbz1bFyMXh5DAdEaJ0z8usoEkhAR+M0pMXx0DYrMJqEl8+XKYHcQWAbJv7pnF
	BNLADNKw7vYFVogGW4lD658xgSzgFLCTeL47CCQsDGRO2PGfGcRmEVCVeLX6KRtICS9Q+Z85
	xSBhXgFBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMcbK6xKO/uiCmiICRROspPYgKEYl9L94x
	TmAUmoVk0Cwkg2YhGTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHR/0xqB+PK
	BotDjAIcjEo8vBZvM4KFWBPLiitzDzFKcDArifDuupgZLMSbklhZlVqUH19UmpNafIgxGejN
	icxSosn5wMSUVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M
	rMtsKrdckJJX3ew/5+Xckt8Pa9i+bfZ8vejfcatrf+YnfeM+279qZ+30jyZKDD4nTvw5+uJp
	Ushsn32rl7qZ71nMYrQ6eV/V069i6Yx+fRcvK5r5OU7dxc1dfzTYulC9OndDa9SlnFO7bZMr
	p0xiOZzkfUtPrnMCh51zYHOBzpHo5E7Ruj9uSizFGYmGWsxFxYkAEzSRLEIDAAA=
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
 drivers/mfd/sm501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index e7dc441..81e6d09 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1726,7 +1726,7 @@ static struct pci_driver sm501_pci_driver = {
 
 MODULE_ALIAS("platform:sm501");
 
-static struct of_device_id of_sm501_match_tbl[] = {
+static const struct of_device_id of_sm501_match_tbl[] = {
 	{ .compatible = "smi,sm501", },
 	{ /* end */ }
 };
-- 
1.7.10.4


