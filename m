Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbaEMK7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:59:07 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64298 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaEMK66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:58:58 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-d9-5371faee7c8c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 02/16] mfd: max14577: Make of_device_id array const
Date: Tue, 13 May 2014 12:58:39 +0200
Message-id: <1399978733-13662-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJMWRmVeSWpSXmKPExsVy+t/xy7rvfhUGG9w7zmPx+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8b5ewvYCq6z
	VnzuvM3ewHiXpYuRk0NCwETi16ojjBC2mMSFe+vZuhi5OIQEljJKLFp4nx0kISTQxyTRuikS
	xGYTMJbYvHwJG4gtIpAl8WPaarBBzAKGEj/f/QGrFxZwlnj29h2YzSKgKtG26wuYzSvgLrG3
	dRbUYjmJk8cms4LYnAIeEi9un2WF2OUucWPVJJYJjLwLGBlWMYqmliYXFCel5xrqFSfmFpfm
	pesl5+duYoSEyZcdjIuPWR1iFOBgVOLhDeAqCBZiTSwrrsw9xCjBwawkwuv+qTBYiDclsbIq
	tSg/vqg0J7X4ECMTB6dUA+Omjzn95+UNIgMaToZfP3Mhn6O731ToWcgph3h/AR75z9O9rR9l
	ODXcn5F5QfmM26PYmuDDTcU9bnc1vzrc3byOrfBau0XcIj52lUrJSc/Lu0/qnGF+NpVr69aM
	j2wl917ZXK5+vHIV+18mhidTJaQP8XWpPr+3VjCNL/9yT+PyM7Ned+19tV+JpTgj0VCLuag4
	EQAVBy/08QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of struct of_device_id should be const as expected by both
of_match_table field and of_match_device() call.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max14577.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 39b658d6497b..372f329a27d5 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -57,7 +57,7 @@ static const struct mfd_cell max77836_devs[] = {
 	},
 };
 
-static struct of_device_id max14577_dt_match[] = {
+static const struct of_device_id max14577_dt_match[] = {
 	{
 		.compatible = "maxim,max14577",
 		.data = (void *)MAXIM_DEVICE_TYPE_MAX14577,
-- 
1.9.1

