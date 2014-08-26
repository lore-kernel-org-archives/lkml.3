Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082AbaHZM5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:57:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51999 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbaHZM5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:57:14 -0400
X-AuditID: cbfee690-f79ce6d00000115a-ad-53fc8428e687
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 01/18] backlight: adp5520: add blank line after declarations
Date: Tue, 26 Aug 2014 21:57:12 +0900
Message-id: <00ab01cfc12d$40e91560$c2bb4020$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAA1hA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zQ12Nlj/BBg8PKlkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBkNKxoY
	Cx6zVmx6vpStgfEjSxcjJ4eEgInEkdd97BC2mMSFe+vZuhi5OIQEljFKTL71nh2m6N+7P+wQ
	iUWMEk/avzFCOL8ZJT4f3skIUsUmoCbx5cthsA4RAQWJzb3PWEFsZoFcid8zV4LVCAnYSszf
	tgIszilgJ7H08DmwemEBH4kXT++BncQioCrx8sgasHpeoPp5nceYIGxBiR+TIWqYBbQk1u88
	zgRhy0tsXvOWuYuRA+hSdYlHf3VBTBEBI4nGmyUQFSIS+168AztZQuAUu8SsI1uZIVYJSHyb
	fIgFolVWYtMBZoh/JSUOrrjBMoFRYhaSxbOQLJ6FZPEsJCsWMLKsYhRNLUguKE5KLzLRK07M
	LS7NS9dLzs/dxAiJygk7GO8dsD7EKMDBqMTDeyP+d7AQa2JZcWXuIUZToIsmMkuJJucDYz+v
	JN7Q2MzIwtTE1NjI3NJMSZz3tdTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MqnrnPh+f
	qrbk3NWMb39FFBpPuthOfdXc+f3zhOsem/ZdZmmr+aFqsqN//TG9LsvFl432m25vf/hQ+kCD
	QGJsx9VP7RbLfLS76m9ec0nq1xOYEaHz5HK38ZfLpyLPf3p3rNznnGxlxc6clq7Gh/M3ivly
	7z2kn8iWLJ6zZvKjroXWh6/aMgsbKLEUZyQaajEXFScCAPS1bSvFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAV2Nlj/BBhf65S2O7pzIZHF54SVW
	i/tfjzJaXN41h82BxWPnrLvsHneu7WHz6NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMhhUNjAWPWSs2PV/K1sD4kaWLkZNDQsBE4t+7P+wQtpjEhXvr
	2boYuTiEBBYxSjxp/8YI4fxmlPh8eCcjSBWbgJrEly+HwTpEBBQkNvc+YwWxmQVyJX7PXAlW
	IyRgKzF/2wqwOKeAncTSw+fA6oUFfCRePL0HtplFQFXi5ZE1YPW8QPXzOo8xQdiCEj8mQ9Qw
	C2hJrN95nAnClpfYvOYtcxcjB9Cl6hKP/uqCmCICRhKNN0sgKkQk9r14xziBUWgWkkGzkAya
	hWTQLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/wz6R2MqxosDjEKcDAq8fDe
	iP8dLMSaWFZcmXuIUYKDWUmE90fSn2Ah3pTEyqrUovz4otKc1OJDjKZAf05klhJNzgemo7yS
	eENjEzMjSyMzCyMTc3Mlcd6DrdaBQgLpiSWp2ampBalFMH1MHJxSwFQjLMSx+tNeH7XYC1Pf
	Vajv4Iy73nO1d1vX2ZfZ576/jJ3779eMTbwsYZpb1Pnvrl/yeO38v0az8wWkMszXHGYMmFLk
	vPiOTy/r7WefE19KyVXOrhes+KfyPDQnV9da8s0esVS3qcwF7fzl7245sj9yvK8i+0JhjfkT
	1b+zxWRk5x5fv9npTZYSS3FGoqEWc1FxIgCOwsvHDwMAAA==
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
 drivers/video/backlight/adp5520_bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index f37097a261a2..8280245d7c12 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -67,6 +67,7 @@ static int adp5520_bl_set(struct backlight_device *bl, int brightness)
 static int adp5520_bl_update_status(struct backlight_device *bl)
 {
 	int brightness = bl->props.brightness;
+
 	if (bl->props.power != FB_BLANK_UNBLANK)
 		brightness = 0;
 
-- 
2.0.0


