Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaB0LjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:39:24 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:51240 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaB0LjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:39:19 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-b3-530f23e617f2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] mfd: ucb1x00-core: Use SIMPLE_DEV_PM_OPS macro
Date: Thu, 27 Feb 2014 20:39:18 +0900
Message-id: <000b01cf33b0$8c7f3000$a57d9000$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8zsIxqTEsSdWYrT/ykVIEeiUcNig==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zfd1nyvzBBh9eS1lcXniJ1eL+16OM
	Fpd3zWGzON3N6sDicefaHjaPeScDPfq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvj8qrn7AWP
	WSvm3exhb2B8zdLFyMEhIWAiseh3fRcjJ5ApJnHh3nq2LkYuDiGBZYwSTddnskMkTCSWNn1k
	h0gsYpTYd2wzC4Tzm1Fi0+OXLCBVbAJqEl++HAbrEAGyb+6ZxQRiMwvkSXzYvJkRxBYWsJe4
	NmcTmM0ioCpx/nwTWC+vgK3EgRnNjBC2oMSPyfdYIHq1JNbvPA41R15i85q3zBBXq0s8+qsL
	sUpPYl3HXjaIEhGJfS/eMYLcJiGwjl3i48vlTBC7BCS+TT4E9bGsxKYDzBCPSUocXHGDZQKj
	2Cwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRESYb07GG8fsD7E
	mAy0fiKzlGhyPjBC80riDY3NjCxMTUyNjcwtzUgTVhLnTXqYFCQkkJ5YkpqdmlqQWhRfVJqT
	WnyIkYmDU6qB0duxRH9KZhqPnazUs3jZI+m6aQqGp9vyRT7mP37swnquZq324s1PLqx/l+70
	im1VzD4hAQaNM/En3aYeUVq7T0if/9yEI9+XBjysZ31/aO26fv0pspnaNnyPWuZ2Mz8N/Plt
	/ZuDp8Lnvf8kd9n62LKYp/08fd4iN2aImE+qeO3wfuKOr10H2JRYijMSDbWYi4oTAa7QUOzG	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd1nyvzBBpPniVtcXniJ1eL+16OM
	Fpd3zWGzON3N6sDicefaHjaPeScDPfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4x4/Kq5+wFj1kr5t3sYW9gfM3SxcjJISFgIrG06SM7hC0mceHeerYu
	Ri4OIYFFjBL7jm1mgXB+M0psevwSrINNQE3iy5fDYB0iQPbNPbOYQGxmgTyJD5s3M4LYwgL2
	EtfmbAKzWQRUJc6fbwLr5RWwlTgwo5kRwhaU+DH5HgtEr5bE+p3HoebIS2xe85a5i5ED6CJ1
	iUd/dSFW6Ums69jLBlEiIrHvxTvGCYwCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911Cv
	ODG3uDQvXS85P3cTIziCn0ntYFzZYHGIUYCDUYmHV4GNL1iINbGsuDL3EKMEB7OSCO96Jv5g
	Id6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4HJpe8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoH
	CgmkJ5akZqemFqQWwWxh4uCUamCc+K9lAfvLyNNSd1JN5E8cPCWkkiwUl8h9X/f07M8d0y+n
	y78U8PvB+WH6YlvdKY63lT+3zXNdYcFy+DDHriT5xHMffX9E3Vd4xF7evb+1sWnSvVDeg9HF
	ZUmvNiQ7yG85eMJh1yztGK5qzROXxddLSN1yvaQmNz1rqs3Hn/l3Pi2v0Pzw5ZikEktxRqKh
	FnNRcSIAiJyGSyQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use SIMPLE_DEV_PM_OPS macro in order to make the code simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/ucb1x00-core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index 0313f83..153d595 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -742,9 +742,7 @@ static int ucb1x00_resume(struct device *dev)
 }
 #endif
 
-static const struct dev_pm_ops ucb1x00_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(ucb1x00_suspend, ucb1x00_resume)
-};
+static SIMPLE_DEV_PM_OPS(ucb1x00_pm_ops, ucb1x00_suspend, ucb1x00_resume);
 
 static struct mcp_driver ucb1x00_driver = {
 	.drv		= {
-- 
1.7.10.4


