Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553AbaHZNBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:01:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8237 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbaHZNBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:01:31 -0400
X-AuditID: cbfee690-f79ce6d00000115a-48-53fc8529644f
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 14/18] backlight: tdo24m: add blank line after declarations
Date: Tue, 26 Aug 2014 22:01:29 +0900
Message-id: <00b801cfc12d$da62a260$8f27e720$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAKiUw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI12t1j/BBu+OMloc3TmRyeLywkus
	Fve/ArmXd81hc2Dx2DnrLrvHnWt72Dz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr49uG90wF
	a9kqbk2+xdLAOI+1i5GTQ0LAROLNmcOMELaYxIV769m6GLk4hASWMUr0HTkMV/R66SaoxCJG
	iWlLbzBBOL8ZJV7t3ckMUsUmoCbx5cthdhBbREBBYnPvM7BuZoFcid8zV4KtEBKwlZi/bQVY
	nFPATmLp4XNg9cIC3hLz+n+D2SwCqhJ3P/eC1fAC1W99+58NwhaU+DH5HgvETC2J9TuPM0HY
	8hKb17wFuoED6FJ1iUd/dSFOMJKYe3E/I0SJiMS+F+8YQW6WEDjFLvGl/RUTxC4BiW+TD7FA
	9MpKbDrADPGwpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRSZ6xYm5xaV5
	6XrJ+bmbGCFxOWEH470D1ocYBTgYlXh4b8T/DhZiTSwrrsw9xGgKdNFEZinR5Hxg9OeVxBsa
	mxlZmJqYGhuZW5opifO+lvoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGxt+esRpZE6iTz
	j0ey2HgfBGcb8qYuvmYw7Y1dWOMLodlR51zXGPHGFAmprqswfJLXU9yf2vbsc0DozjDbRIdt
	FjJyHyY3TZTw913D8vq3+uf5K60iRJ0cOfmP2M9eWZkxpeBH7Cx38+fL2Rf4fH++6f3+i+Xp
	b6v23znItm3lzXe7uDK89lYosRRnJBpqMRcVJwIA4xt5WcYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAV3N1j/BBg/nWlsc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZ3za8ZypYy1Zxa/ItlgbGeaxdjJwcEgImEq+XbmKDsMUkLtxb
	D2RzcQgJLGKUmLb0BhOE85tR4tXencwgVWwCahJfvhxmB7FFBBQkNvc+A5vELJAr8XvmSkYQ
	W0jAVmL+thVgcU4BO4mlh8+B1QsLeEvM6/8NZrMIqErc/dwLVsMLVL/17X82CFtQ4sfkeywQ
	M7Uk1u88zgRhy0tsXvMW6AYOoEvVJR791YU4wUhi7sX9jBAlIhL7XrxjnMAoNAvJpFlIJs1C
	MmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKj/pn0DsZVDRaHGAU4GJV4eG/E
	/w4WYk0sK67MPcQowcGsJML7I+lPsBBvSmJlVWpRfnxRaU5q8SFGU6BHJzJLiSbnAxNSXkm8
	obGJmZGlkZmFkYm5uZI478FW60AhgfTEktTs1NSC1CKYPiYOTqkGxga1/3onnm3jf8CfurMh
	aTcLx6mP969aHT/5hn328eSDrpHqV8U6NTsUpKbvPuwUeSDcsSkzePsCT36TaQfzIwVcOTMW
	aPyzTby0SqOx4tfJZ+eWP7ypcehpbonMHbdaGZXWDxd3lAUqPgoS5czXnZlx+WbFtOmrb3By
	G/Z1rn66ZL3ItPnbNyuxFGckGmoxFxUnAgAR7hXsEAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: Missing a blank line after declarations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/tdo24m.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index 908016fc5829..30afce33ef2a 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -300,12 +300,14 @@ static int tdo24m_power(struct tdo24m *lcd, int power)
 static int tdo24m_set_power(struct lcd_device *ld, int power)
 {
 	struct tdo24m *lcd = lcd_get_data(ld);
+
 	return tdo24m_power(lcd, power);
 }
 
 static int tdo24m_get_power(struct lcd_device *ld)
 {
 	struct tdo24m *lcd = lcd_get_data(ld);
+
 	return lcd->power;
 }
 
-- 
2.0.0


