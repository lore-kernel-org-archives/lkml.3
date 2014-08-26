Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934505AbaHZM74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:59:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52222 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbaHZM7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:59:54 -0400
X-AuditID: cbfee68f-f797f6d000001173-d2-53fc84c897f7
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 09/18] backlight: lm3639: remove unnecessary return statements
Date: Tue, 26 Aug 2014 21:59:52 +0900
Message-id: <00b301cfc12d$a0831cf0$e18956d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAG3xA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zA90TLX+CDWZPtrI4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDKa911j
	LZjIXrFw/l7WBsafrF2MnBwSAiYSBx/uYoawxSQu3FvP1sXIxSEksIxR4u3fj3BFPzZ0MUEk
	pjNK7Nu5jBXC+c0o0TD9EyNIFZuAmsSXL4fZQWwRAQWJzb3PwLqZBXIlfs9cCVYjJGArMX/b
	CrA4p4CdxNLD54DqOTiEBfwkul6BhVkEVCUudZ4GK+cFKj+8rA3KFpT4MfkeC8RILYn1O48z
	QdjyEpvXvGUGGSMhoC7x6K8uxAVGEu/2dEFdICKx78U7RpCTJQSOsUucvNXGArFLQOLb5EMs
	EL2yEpsOQANCUuLgihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0ImO94sTc4tK8
	dL3k/NxNjJCo7N/BePeA9SFGAQ5GJR7em/G/g4VYE8uKK3MPMZoCXTSRWUo0OR8Y+3kl8YbG
	ZkYWpiamxkbmlmZK4rwLpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamA0T8iNcd1ttk/x
	+slTB9fXrurXY2Y4t2m5pMJ39bL3lYdnCcS/+/LI4a2VgIZc8jb1M/7/WgML1p86Gnw+fFbl
	abN1bcuNmH+05E4rOr7WSfrX0zTDDoY9L39tNUxgePoxjeHIzK4Yx1OHBF7sS3m9OFt445FV
	h56tf/72UPdXGS9r1565P3eHKrEUZyQaajEXFScCAMC4deTFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd0TLX+CDfZeNbM4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzmvddYy2YyF6xcP5e1gbGn6xdjJwcEgImEj82dDFB2GISF+6t
	Z+ti5OIQEpjOKLFv5zJWCOc3o0TD9E+MIFVsAmoSX74cZgexRQQUJDb3PgObxCyQK/F75kqw
	GiEBW4n521aAxTkF7CSWHj4HVM/BISzgJ9H1CizMIqAqcanzNFg5L1D54WVtULagxI/J91gg
	RmpJrN95nAnClpfYvOYtM8gYCQF1iUd/dSEuMJJ4t6cL6gIRiX0v3jFOYBSahWTSLCSTZiGZ
	NAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwTH/TGoH48oGi0OMAhyMSjy8N+J/
	BwuxJpYVV+YeYpTgYFYS4f2R9CdYiDclsbIqtSg/vqg0J7X4EKMp0KMTmaVEk/OB6SivJN7Q
	2MTMyNLIzMLIxNxcSZz3QKt1oJBAemJJanZqakFqEUwfEwenVAPj2UghbUMFh01HooV8d+9X
	yBEPj7u25qb/81UxVoFrODmlF+z2cW61rPWet/hITIGJ5ssVWvNuPzKNX67wVdYybPe3lgd1
	Hnf1+q571UktvhMoypz1YPvM97JOG7UVLGaJBpSekTt77PbBVc+v6v/PvVK58GvKockBQlxV
	NX/bez7oTDToVr2kxFKckWioxVxUnAgArZZOOA8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: void function return statements are not generally useful

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lm3639_bl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
index 5f36808d214f..cd50df5807ea 100644
--- a/drivers/video/backlight/lm3639_bl.c
+++ b/drivers/video/backlight/lm3639_bl.c
@@ -254,7 +254,6 @@ static void lm3639_torch_brightness_set(struct led_classdev *cdev,
 	return;
 out:
 	dev_err(pchip->dev, "i2c failed to access register\n");
-	return;
 }
 
 /* flash */
@@ -293,7 +292,6 @@ static void lm3639_flash_brightness_set(struct led_classdev *cdev,
 	return;
 out:
 	dev_err(pchip->dev, "i2c failed to access register\n");
-	return;
 }
 
 static const struct regmap_config lm3639_regmap = {
-- 
2.0.0


