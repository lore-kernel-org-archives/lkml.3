Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbaHZNBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:01:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32421 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbaHZNA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:00:57 -0400
X-AuditID: cbfee68d-f79c46d000000b84-64-53fc85074f2f
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 12/18] backlight: pcf50633: add blank line after declarations
Date: Tue, 26 Aug 2014 22:00:55 +0900
Message-id: <00b601cfc12d$c5e51ed0$51af5c70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAI5cQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI1321j/BBrO/Gloc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBkt3RuY
	Cj6yVqx6MZepgbGNtYuRk0NCwERi5t+TzBC2mMSFe+vZuhi5OIQEljFKPD62jw2maPa9M0wg
	tpDAIkaJLW+iIYp+M0psmPcIbBKbgJrEly+H2UFsEQEFic29z8DizAK5Er9nrmSEaLaVmL9t
	BVicU8BOYunhc2D1wgK+Es9OPANbwCKgKvHjcB9YnBeoftGnw2wQtqDEj8n3WCBmakms33mc
	CcKWl9i85i3QBxxAh6pLPPqrC3GCkcT1ZbOgykUk9r14xwhys4TAMXaJOZcfMUPsEpD4NvkQ
	C0SvrMSmA9CAkJQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchQrzgxt7g0
	L10vOT93EyMkKnt3MN4+YH2IUYCDUYmH90b872Ah1sSy4srcQ4ymQBdNZJYSTc4Hxn5eSbyh
	sZmRhamJqbGRuaWZkjivotTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M+4+78mtJ61/J
	iV+3X6o2Ss0vRHXLYvvjrJaShx/2mByxurOX51PTP38NFVOdmn7OpRVX5fhrJsu8eZX2YZPZ
	xKNOnnPmNkXJLJeuX6iRUl/+c4fbppPBbHsd7+youtqk9G9u6d0jKkJLCxdoMi26/CF6tk7p
	WqO3Wgbr90SrXHm6NCT53dxlSizFGYmGWsxFxYkA1M69dsUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAV321j/BBh/W6Fkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZLd0bmAo+slasejGXqYGxjbWLkZNDQsBEYva9M0wQtpjEhXvr
	2UBsIYFFjBJb3kR3MXIB2b8ZJTbMewTWwCagJvHly2F2EFtEQEFic+8zsDizQK7E75krGSGa
	bSXmb1sBFucUsJNYevgcWL2wgK/EsxPPwJaxCKhK/DjcBxbnBapf9OkwG4QtKPFj8j0WiJla
	Eut3HmeCsOUlNq95y9zFyAF0qLrEo7+6ECcYSVxfNguqXERi34t3jBMYhWYhmTQLyaRZSCbN
	QtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwzD+T2sG4ssHiEKMAB6MSD++N+N/B
	QqyJZcWVuYcYJTiYlUR4fyT9CRbiTUmsrEotyo8vKs1JLT7EaAr06ERmKdHkfGA6yiuJNzQ2
	MTOyNDKzMDIxN1cS5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwCiz/eyL4M0fUtxkLH3mPjj/
	4crOZSd/VS2SZi6+8uFkpleCpsUhZyU7iWlHpt7zqK6+8kpP6e7B7/tDKp9Pm/87zV9167/K
	BxqRPEmzjfs5Tl/wqnOT4UpQnutxbv8ua9NyK76M+przHzJYdkvcvWk1K08k0v29x/v7P68s
	7v3U80He5Wl29l4lluKMREMt5qLiRACjEpOBDwMAAA==
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


