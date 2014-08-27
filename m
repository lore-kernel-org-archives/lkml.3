Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaH0BNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:13:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23746 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbaH0BNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:13:12 -0400
X-AuditID: cbfee690-f79ce6d00000115a-95-53fd30a73688
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 12/18] backlight: pcf50633: add blank line after declarations
Date: Wed, 27 Aug 2014 10:13:10 +0900
Message-id: <005001cfc194$1185b690$349123b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAJ6VQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI93lBn+DDT7N57c4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDLO/X3F
	WDCXraL/6Uz2Bsa1rF2MnBwSAiYS79qfsUDYYhIX7q1nA7GFBJYxSizbyg5T86yxGSjOBRRf
	xCjRumUDO4Tzm1Fiw8VlYJPYBNQkvnw5DNYhIqAgsbn3GVicWSBX4vfMlYwQU20lLi9cywRi
	cwrYScz+MB2sXlggQGLNgQ6wzSwCqhL9nT/AenmB6g8v+8QMYQtK/Jh8jwVippbE+p3HmSBs
	eYnNa94C1XAAXaou8eivLsQJRhJPfvRBlYhI7HvxjhHkZgmBY+wSzY1NzBC7BCS+TT7EAtEr
	K7HpADPEw5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpReZ6BUn5haX5qXr
	JefnbmKEROWEHYz3DlgfYhTgYFTi4f2w4E+wEGtiWXFl7iFGU6CLJjJLiSbnA2M/ryTe0NjM
	yMLUxNTYyNzSTEmc97XUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjGrSa08zSrf8e2Uy
	u//DQdGdRYsf8gnnMbLr1m256bKs/87rgAOJ5x88a9D1s5v4a/tmoztsllKymUbzZ67b9iXw
	AgufTHLu+jUXGDgTZk53sjyWsYRFsUcqvGn5/acyVbzHlb/sehY4RS/6cKYKl9DbvrYja+dk
	xLQdXXTL6p37rC1K132XsiuxFGckGmoxFxUnAgARna2wxQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd3lBn+DDT7+4LY4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzzv19xVgwl62i/+lM9gbGtaxdjJwcEgImEs8am9kgbDGJC/fW
	A9lcHEICixglWrdsYIdwfjNKbLi4DKyDTUBN4suXw+wgtoiAgsTm3mdgcWaBXInfM1cygthC
	ArYSlxeuZQKxOQXsJGZ/mA5WLywQILHmQAfYNhYBVYn+zh9gvbxA9YeXfWKGsAUlfky+xwIx
	U0ti/c7jTBC2vMTmNW+BajiALlWXePRXF+IEI4knP/qgSkQk9r14xziBUWgWkkmzkEyahWTS
	LCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER/0z6R2MqxosDjEKcDAq8fB+WPAn
	WIg1say4MvcQowQHs5IIb7LC32Ah3pTEyqrUovz4otKc1OJDjKZAj05klhJNzgcmpLySeENj
	EzMjSyMzCyMTc3Mlcd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYwifLct71oGckptKu7uN22y
	EpRR8TLVufcoot/sePNTTp8fW3YsThaYfvnRucxczd4ri74e/n/pqnOf09Ypxx5L5XZcWa7r
	dWVB8lH773efKFZ5Ltat+BPCvNdXbGJEpeOXOZ/b9iycGX9o8/Ki7j9mdx+cbXh0RThebWfB
	uv473i8vr98x+VyREktxRqKhFnNRcSIAbZ1PwhADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: Missing a blank line after declarations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/pcf50633-backlight.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/pcf50633-backlight.c b/drivers/video/backlight/pcf50633-backlight.c
index b95d3b0aaffe..85bd573b6d15 100644
--- a/drivers/video/backlight/pcf50633-backlight.c
+++ b/drivers/video/backlight/pcf50633-backlight.c
@@ -90,6 +90,7 @@ static int pcf50633_bl_update_status(struct backlight_device *bl)
 static int pcf50633_bl_get_brightness(struct backlight_device *bl)
 {
 	struct pcf50633_bl *pcf_bl = bl_get_data(bl);
+
 	return pcf_bl->brightness;
 }
 
-- 
2.0.0


