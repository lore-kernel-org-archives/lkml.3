Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab3HIEGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:06:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41877 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3HIEGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:06:37 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-d3-52046acc6584
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Nick Piggin'" <npiggin@kernel.dk>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/3] block: brd: Staticize 'rd_size'
Date: Fri, 09 Aug 2013 13:06:35 +0900
Message-id: <001a01ce94b5$d72a5430$857efc90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: Ac6Utb+jbAxgCKjcTTWno9nl0kH+ww==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zQ90zWSxBBi8ei1nMWb+GzeLywkus
	Fpd3zWGzuPa/l92BxePy2VKPEzN+s3j0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxo+r+1gK
	5rJVHGx4wNrAOJG1i5GTQ0LARGLOqRlQtpjEhXvr2boYuTiEBJYxSjx8/4UJpujHs1ZWiMQi
	Rond83rZIZxfjBJPprYxg1SxCahJfPlyGCjBwSEioC/R1qIBEmYWSJe4uBeiRBho0KEv99hB
	bBYBVYnX/2aALeAVsJSY/GA6C4QtKPFj8j0WiF4tic3bmlghbHmJzWveMkMcpCCx4+xrRoi4
	iMS+F+8YIdbqSbRO9gM5TUJgHbvE2/mfWSB2CUh8m3yIBaRGQkBWYtMBqDGSEgdX3GCZwCg2
	C8nmWUg2z0KyeRaSbQsYWVYxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525ihMRY7w7G2wesDzEm
	A62fyCwlmpwPjNG8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTA2rDGUXq1m5HD27IErb7ZGBMlttZfpMJttJi2TE9PjWP705SvmyCf5Uj+LzfLb
	39ziMzuxcbnHqWBGt0Nnt1zJLM+c82RLGeNKKS3tnexiH7/d+LbsmK21ivOrfQF/37QqczqU
	5VmkXlsmtmGGbUfedckcDkffO4kzHgZWvJkcUnRstseFR7JKLMUZiYZazEXFiQC5cWwhxwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd0zWSxBBhd3CFvMWb+GzeLywkus
	Fpd3zWGzuPa/l92BxePy2VKPEzN+s3j0bVnF6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8aPq/tYCuayVRxseMDawDiRtYuRk0NCwETix7NWKFtM4sK99Wxd
	jFwcQgKLGCV2z+tlh3B+MUo8mdrGDFLFJqAm8eXLYaAEB4eIgL5EW4sGSJhZIF3i4l6IEmGg
	oYe+3GMHsVkEVCVe/5vBBGLzClhKTH4wnQXCFpT4MfkeC0SvlsTmbU2sELa8xOY1b5khDlKQ
	2HH2NSNEXERi34t3jBBr9SRaJ/tNYBSYhWTSLCSTZiGZNAtJ9wJGllWMoqkFyQXFSem5hnrF
	ibnFpXnpesn5uZsYwRH8TGoH48oGi0OMAhyMSjy8ituZg4RYE8uKK3MPMUpwMCuJ8L7IAgrx
	piRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjC55JXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBI
	ID2xJDU7NbUgtQhmCxMHp1QD456aib8mnd5v3v4m+8qti9ksy9QbOnhqdmw22iJnUpI8a7v3
	+VDP8wyJF05Fhl2Z88xd6g9nz/EPu/LKTtif9N7460eLz4xlry99ebj6q4Jw7cq016+uv6hf
	p9BgYX7GM6smbtGtrKcLcgrDuK/0bnwuke6Yd3n9onMpzYcmeDZ7PEmJEd667aISS3FGoqEW
	c1FxIgDhZRDiJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'rd_size' is used only in this file.
Fix the following sparse warning:

drivers/block/brd.c:432:5: warning: symbol 'rd_size' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/block/brd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 9bf4371..650530ab 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -429,7 +429,7 @@ static const struct block_device_operations brd_fops = {
  * And now the modules code and kernel interface.
  */
 static int rd_nr;
-int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
+static int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
 static int max_part;
 static int part_shift;
 module_param(rd_nr, int, S_IRUGO);
-- 
1.7.10.4


