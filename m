Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaIDPCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:02:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47058 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaIDPBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:01:52 -0400
X-AuditID: cbfee68e-f79536d000000fd1-95-54087edd8f74
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 3/4] mfd: max77693: add haptic of_compatible in mfd_cell
Date: Fri, 05 Sep 2014 00:01:30 +0900
Message-id: <1409842891-26549-4-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1409842891-26549-1-git-send-email-jaewon02.kim@samsung.com>
References: <1409842891-26549-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkUPduHUeIwcwPAhbXvzxntTi86AWj
	xY6GI6wW978eZbS4+ekbq8XlXXPYLE53szqwe+ycdZfd4861PWwe804GevRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAldG1/n1LAUH2Cr+PIpqYFzJ2sXIySEhYCKx9vlvZghbTOLCvfVsXYxc
	HEICSxklGo50wRVta53FCpGYzihxZvVJFginjUni2oIOdpAqNgFtie/rF4N1iAhUSvR3vwDr
	YBboYZT43r4abIewgLdE2+k3YEUsAqoSW55MZwSxeQU8JBo7jgDZHEDrFCTmTLIBCXMKeEp0
	PVjBAmILAZUsmPINbLGEwHR2ifY3Cxkh5ghIfJt8iAWiV1Zi0wGodyQlDq64wTKBUXgBI8Mq
	RtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjMAQP/3vWd8OxpsHrA8xCnAwKvHwFrxgDxFiTSwr
	rsw9xGgKtGEis5Rocj4wkvJK4g2NzYwsTE1MjY3MLc2UxHkTpH4GCwmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamBUDjlifGS9yqyP226L3Y5dcD2qLtuSsfOKXUiTtk5AcIT710Ob9E4+Zpt9
	b1pHoL5CnlCpfkld/tYZ/Bsmdtol+H1aNdcq/fGxOxKRsddv1L0v/nI28UYvo77ve37Hii1v
	sra57Lyy7uy+sovz3D5t7J1wVE84bJ9pfsmV1amLv+QWT8vW7uJQYinOSDTUYi4qTgQAV52N
	gWwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jQd27dRwhBtf/clpc//Kc1eLwoheM
	FjsajrBa3P96lNHi5qdvrBaXd81hszjdzerA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM7rOr2cpOMBW8ecR0EErWbsY
	OTkkBEwktrXOgrLFJC7cW8/WxcjFISQwnVHizOqTLBBOG5PEtQUd7CBVbALaEt/XLwbrEBGo
	lOjvfsEKUsQs0MMo8b19NTNIQljAW6Lt9BuwIhYBVYktT6Yzgti8Ah4SjR1HgGwOoHUKEnMm
	2YCEOQU8JboerGABsYWAShZM+cYygZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg
	CHomtYNxZYPFIUYBDkYlHt6CF+whQqyJZcWVuYcYJTiYlUR43fM4QoR4UxIrq1KL8uOLSnNS
	iw8xmgIdNZFZSjQ5HxjdeSXxhsYmZkaWRuaGFkbG5krivAdarQOFBNITS1KzU1MLUotg+pg4
	OKUaGK3l1goZFblrTf3vv71j1/anzQonNy79HfRtXqakp0v/xu3mBu6VTKdvsywR2Xsx4cHG
	2cqnFq3csmr5zANlk+Y8kn5e53Rb6fQW5+hZxe4SO8y2etyb3WwZrPFlyq/U4z8VnKLD3mi9
	lI8uFJN4Up4kWha3lfGwtcaxhW2p8SpWPxfbHAr7tlSJpTgj0VCLuag4EQDfILFptgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add haptic of_compatible in order to use the haptic
device driver using Devicetree.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/mfd/max77693.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index fbfed56..03fd431 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -46,7 +46,10 @@ static const struct mfd_cell max77693_devs[] = {
 	{ .name = "max77693-charger", },
 	{ .name = "max77693-flash", },
 	{ .name = "max77693-muic", },
-	{ .name = "max77693-haptic", },
+	{
+	  .name = "max77693-haptic",
+	  .of_compatible = "maxim,max77693-haptic",
+	},
 };
 
 static const struct regmap_config max77693_regmap_config = {
-- 
1.7.9.5

