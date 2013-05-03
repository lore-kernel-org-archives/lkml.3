Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861Ab3ECGdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:33:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22146 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762770Ab3ECGdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:33:10 -0400
X-AuditID: cbfee690-b7f136d000000fea-08-51835a247f10
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 26/42] rtc: rtc-msm6242: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:33:08 +0900
Message-id: <002801ce47c8$1391da00$3ab58e00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyBGn9OwxEjdeTbSGcp84aA0keQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zY12VqOZAgy+bTSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuNC2gb3gBlfF66d3WBsYn3B0MXJySAiYSOyaNI8dwhaTuHBvPVsXIxeHkMAyRokd
	e2+wwhSt3P2BBSKxiFFi1vzNrBDOL0aJr/vvMIJUsQmoSXz5chhoFAeHiIC+RFuLBkgNs0A3
	o8Sj5rnMIDXCAiESPTuXMIHYLAKqEncbF4PFeQUsJRoOvIGyBSV+TL7HAmIzC2hJrN95nAnC
	lpfYvOYtM8RFChI7zr4G2ysioCcx/dB1dogaEYl9L94xQtQcY5c4srsMYpeAxLfJh1hAbpMQ
	kJXYdABqjKTEwRU3WCYwis1CsnkWks2zkGyehWTDAkaWVYyiqQXJBcVJ6UUmesWJucWleel6
	yfm5mxghsTdhB+O9A9aHGJOB1k9klhJNzgfGbl5JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFC
	AumJJanZqakFqUXxRaU5qcWHGJk4OKUaGOvs7t4v/RTZLZ8xd930exlHLoVY2V9nzFf9eJH7
	ffQkJyGlM3Kr2AoZdh0uLHJK/1ZZorl217wj+j9ryg/lrbXxumvtK7dJ7qnb5VeZz2/942t+
	Iyf6+U2+86fF8hV7StK8vB+oLFmTsH63nY++zHvThyrTrEJOczMYRcw42RXh77tt9Yq9L5VY
	ijMSDbWYi4oTAWiBfBDTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAV2VqOZAg667BhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZlxo28BecIOr4vXTO6wNjE84uhg5OSQETCRW
	7v7AAmGLSVy4t56ti5GLQ0hgEaPErPmbWSGcX4wSX/ffYQSpYhNQk/jy5TB7FyMHh4iAvkRb
	iwZIDbNAN6PEo+a5zCA1wgIhEj07lzCB2CwCqhJ3GxeDxXkFLCUaDryBsgUlfky+B7aZWUBL
	Yv3O40wQtrzE5jVvmSEuUpDYcfY12F4RAT2J6Yeus0PUiEjse/GOcQKjwCwko2YhGTULyahZ
	SFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO7WdSOxhXNlgcYhTgYFTi4VVoaQoU
	Yk0sK67MPcQowcGsJMLr9gMoxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKiyfnAtJNXEm9obGJm
	ZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYwhzNsdX1ROdhW/VChWnVUQ
	O/FYEKfSbW7XTe4+HQ/XHRecPvN4hqugo9x5tr4ipwYBbt+5s54FvWRzWDfXTaLv00312zLx
	BzeoPtKJPPtpgeS9WRu/zPvv1bZWfoLwDUmWnmifjS67fP9kP7q27d2m1wWNDI4CUxkWZ/au
	Xab01Xeh8Zbd874rsRRnJBpqMRcVJwIA7uY6VTEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-msm6242.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
index 771f86a..3b300ec 100644
--- a/drivers/rtc/rtc-msm6242.c
+++ b/drivers/rtc/rtc-msm6242.c
@@ -199,7 +199,6 @@ static int __init msm6242_rtc_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct msm6242_priv *priv;
 	struct rtc_device *rtc;
-	int error;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -216,17 +215,11 @@ static int __init msm6242_rtc_probe(struct platform_device *pdev)
 
 	rtc = devm_rtc_device_register(&pdev->dev, "rtc-msm6242",
 				&msm6242_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		error = PTR_ERR(rtc);
-		goto out_unmap;
-	}
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 
 	priv->rtc = rtc;
 	return 0;
-
-out_unmap:
-	platform_set_drvdata(pdev, NULL);
-	return error;
 }
 
 static int __exit msm6242_rtc_remove(struct platform_device *pdev)
-- 
1.7.2.5


