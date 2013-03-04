Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3CDJCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:02:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61843 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab3CDJCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:02:18 -0500
X-AuditID: cbfee690-b7f6b6d000004563-95-513463188559
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <015501ce18b6$3819c310$a84d4930$%han@samsung.com>
In-reply-to: <015501ce18b6$3819c310$a84d4930$%han@samsung.com>
Subject: [PATCH V2] backlight: ep93xx_bl: remove incorrect __init annotation
Date: Mon, 04 Mar 2013 18:02:16 +0900
Message-id: <015701ce18b6$f7f42450$e7dc6cf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YtjgDnfWDblDbSP+ou/QMT1c6bgAAK/Gw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zA12JZJNAg6mblSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGxjM9jAV97BU9lx4xNjA2sHUxcnBICJhIXP6u3cXICWSKSVy4
	t54NxBYSWMYosWFOMUTcRGLW9scsXYxcQPFFjBLPpl1gg3BmM0nM6rwL1sEmoCbx5cthdpCh
	IgL6Em0tGiBhZoFSia0P3rNADLWVuDrlAxOIzSlgJ/Fkw15WEFtYwEfiyrH3jCA2i4CqxP//
	18FsXqD63ku7mCFsQYkfk++xQMzUkli/8zgThC0vsXnNW2aIX9QlHv3VBQmLCBhJdPQfZYYo
	EZHY9+IdI8jJEgKL2CVaLi+E2iUg8W3yIRaIXlmJTQeYIf6VlDi44gbLBEaJWUg2z0KyeRaS
	zbOQrFjAyLKKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIySqJuxgvHfA+hBjMtD6icxSosn5
	wKjMK4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG
	wLO6i1U/Sh+ve2Le9W+9Xic78/0TokwH3JZ3HBF0CM469mbW7DORgq9zfig+VN7JPeXpEZlA
	vynXpSZP8amOP6Zk9uLw2wlrlk95sJJxRum91V2zjKdPidNhWGe45uEtJfnKEBWRxI5/m9MD
	71Vs36rTwxR1SXRqtZoYY8SJ7QltRY+t2X/oKbEUZyQaajEXFScCAPON1ajAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK5EskmgwYNXchaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY+OZHsaCPvaKnkuPGBsY
	G9i6GDk5JARMJGZtf8wCYYtJXLi3HijOxSEksIhR4tm0C1DObCaJWZ13wTrYBNQkvnw5zN7F
	yMEhIqAv0daiARJmFiiV2PrgPdggIQFbiatTPjCB2JwCdhJPNuxlBbGFBXwkrhx7zwhiswio
	Svz/fx3M5gWq7720ixnCFpT4MfkeC8RMLYn1O48zQdjyEpvXvGUGWSshoC7x6K8uSFhEwEii
	o/8oM0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k
	/NxNjOC4fSa1g3Flg8UhRgEORiUeXoFPxoFCrIllxZW5hxglOJiVRHgjEkwChXhTEiurUovy
	44tKc1KLDzEmAz06kVlKNDkfmFLySuINjU3MjCyNzCyMTMzNSRNWEudlPPUkQEggPbEkNTs1
	tSC1CGYLEwenVANjid9mQ8sZnRsTik8UnZfqEWleJXCErVzv0OYlF3L/OFuXeTEZKleHLLzE
	bsk0o1zwi2DWfdG08mf8h6/djnjue3P6zGDLYr9J2SGP7nAe3ffHmanuIYegZU/KzkWyes8m
	RZnrpneJS6hemu72n1nsh8yGvuXbLRYvuih6Uyg1+YCTg1a4Q64SS3FGoqEWc1FxIgA2f+Bl
	HwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform_driver_probe() is not used, bind/unbind via sysfs is
enabled. Thus, __init/__exit annotations should be removed from
probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Fix typo of the subject: __exit --> __init

 drivers/video/backlight/ep93xx_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index ef3e21e..fd073b2 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -60,7 +60,7 @@ static const struct backlight_ops ep93xxbl_ops = {
 	.get_brightness	= ep93xxbl_get_brightness,
 };
 
-static int __init ep93xxbl_probe(struct platform_device *dev)
+static int ep93xxbl_probe(struct platform_device *dev)
 {
 	struct ep93xxbl *ep93xxbl;
 	struct backlight_device *bl;
-- 
1.7.2.5


