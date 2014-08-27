Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbaH0BO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:14:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43381 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbaH0BO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:14:27 -0400
X-AuditID: cbfee68e-f79536d000000fd1-2a-53fd30f13a0b
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 16/18] backlight: jornada720: remove 'else' after a return
Date: Wed, 27 Aug 2014 10:14:25 +0900
Message-id: <005401cfc194$3e0836c0$ba18a440$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAMoeg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zY92PBn+DDWadtrA4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDLWne9i
	LDjJXvF9dWkD43K2LkZODgkBE4nX3a9YIWwxiQv31gPFuTiEBJYxSlzePpEJpuh812awIiGB
	6YwSnz86QBT9ZpSYsn8SC0iCTUBN4suXw+wgtoiAgsTm3mdgDcwCuRK/Z65khGi2lbi8cC3Y
	UE4BO4nZH6aD1QsL+Er0rnoBFmcRUJXYf7Qd7DpeoPpX7SeYIGxBiR+T77FAzNSSWL/zOBOE
	LS+xec1b5i5GDqBD1SUe/dWFOMFI4v/1uVAlIhL7XrxjBLlZQuAQu8Sxlb3MELsEJL5NPsQC
	0SsrsekAM8S/khIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelFxnpFSfmFpfm
	pesl5+duYoTEZN8OxpsHrA8xCnAwKvHwfljwJ1iINbGsuDL3EKMp0EUTmaVEk/OBkZ9XEm9o
	bGZkYWpiamxkbmmmJM6bIPUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPj1Gsxd/wCPVwj
	pl98/7O1a/XTuwl1x/4XCj+uO3bG5cQHAzadWy8Z/uyc93493+2fVx4KrXh4466lcO+juLQ0
	hof1zyLjZ7zdzyu6890p3/++25jkhYvybT9Nyl93ROXSlAsPjO54+uw2OxHT6X8wu9qrwPnl
	gz8Hn8rGPjljc8U04l9lT8oCZSWW4oxEQy3mouJEAGhUjejEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQd2PBn+DDb42mloc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZ6853MRacZK/4vrq0gXE5WxcjJ4eEgInE+a7NrBC2mMSFe+vB
	4kIC0xklPn906GLkArJ/M0pM2T+JBSTBJqAm8eXLYXYQW0RAQWJz7zOwZmaBXInfM1cyQjTb
	SlxeuJYJxOYUsJOY/WE6WL2wgK9E76oXYHEWAVWJ/UfbwZbxAtW/aj/BBGELSvyYfI8FYqaW
	xPqdx5kgbHmJzWveMncxcgAdqi7x6K8uxAlGEv+vz4UqEZHY9+Id4wRGoVlIJs1CMmkWkkmz
	kLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc8c+kdjCubLA4xCjAwajEw/txwZ9g
	IdbEsuLK3EOMEhzMSiK8yQp/g4V4UxIrq1KL8uOLSnNSiw8xmgI9OpFZSjQ5H5iM8kriDY1N
	zIwsjcwsjEzMzZXEeQ+0WgcKCaQnlqRmp6YWpBbB9DFxcEo1MHa2nvi1RsH15YajfdIVWw48
	/CFmN/X6Ol42b43ymVO3+JX59IvPUHlz4tgDaX5zi1K31/kLZmxvD+ZL2KO3R0Vj8dy6LLPl
	Gqlb7u1R32IeeiOvZ8okya7s42sC8m6aXd6nvEaaRetFQcjl9oha3ihhr+z0GTWbyz0PGqml
	Gh0O47ur77XgkxJLcUaioRZzUXEiAORX16UOAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: else is not generally useful after a break or return

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/jornada720_bl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 6ce96b4a8796..7e6ff5346892 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -41,11 +41,11 @@ static int jornada_bl_get_brightness(struct backlight_device *bd)
 		dev_err(&bd->dev, "get brightness timeout\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
-	} else {
-		/* exchange txdummy for value */
-		ret = jornada_ssp_byte(TXDUMMY);
 	}
 
+	/* exchange txdummy for value */
+	ret = jornada_ssp_byte(TXDUMMY);
+
 	jornada_ssp_end();
 
 	return BL_MAX_BRIGHT - ret;
-- 
2.0.0


