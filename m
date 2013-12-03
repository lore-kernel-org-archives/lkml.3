Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3LCGvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 01:51:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:53028 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab3LCGvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 01:51:08 -0500
X-AuditID: cbfee690-b7f676d00000310d-c0-529d7f5a03b9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Magnus Damm'" <damm@igel.co.jp>,
        "'Paul Mundt'" <lethal@linux-sh.org>,
        "'Simon Horman'" <horms+renesas@verge.net.au>,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001ceeff3$e867a100$b936e300$%han@samsung.com>
In-reply-to: <000001ceeff3$e867a100$b936e300$%han@samsung.com>
Subject: [PATCH 2/2] clocksource: sh_mtu2: remove unnecessary
 platform_set_drvdata()
Date: Tue, 03 Dec 2013 15:51:06 +0900
Message-id: <000b01ceeff4$0a6d0a60$1f471f20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7v8+f5y27PXVikS06wEXaGqjqG/gAABRaA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t8zY92o+rlBBksOmVhMmDSB0WLeZ1mL
	C28/sFlcXniJ1WJi0x0Wi/1vf7JaXN41h81i86apzA4cHrM7ZrJ6ND6X8LhzbQ+bx7tz59g9
	Tr8/xOrRt2UVo8ecn99YPD5vkgvgiOKySUnNySxLLdK3S+DKeNqQVdDFVrHh3ALGBsYm1i5G
	Tg4JAROJh48ns0PYYhIX7q1n62Lk4hASWMYocfDADTaYoqbZ89khEosYJWae+ALl/GKU2PX+
	BhNIFZuAmsSXL4fBRokIGEi8Pv0brIhZYBmTRPuRT0AOB1CHrcTxM9wgNZwCdhJXr/xhBLGF
	BcIkrv28ygxiswioStz/tQZsMy9QedPhGywQtqDEj8n3wGxmAS2J9TuPM0HY8hKb17xlBhkv
	IaAu8eivLsQJRhKnP+1lhygRkdj34h0jyDkSAp0cEgtnL2GH2CUg8W3yIRaIXlmJTQeYIR6W
	lDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIyTC
	J+xgvHfA+hBjMtD6icxSosn5wASRVxJvaGxmZGFqYmpsZG5pRpqwkjiv2qOkICGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2MpiGrhdeYf59dePHg9eb5tQn23XJadV27lN6auLz3ihU5vG7i
	5f2pZbkLl34S3vFvV+oWjc2elppbpk9ZGc/rrDohkrVft8gv7L/ymuNdGrwx4mZpKxm29D76
	sPF7yOrVJkp3jSLFH/mHvrVe//jr98YPMRes1X74/v91eT233U5dThndLM4wJZbijERDLeai
	4kQAN3MiwQYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t9jAd2o+rlBBp96DSwmTJrAaDHvs6zF
	hbcf2CwuL7zEajGx6Q6Lxf63P1ktLu+aw2axedNUZgcOj9kdM1k9Gp9LeNy5tofN4925c+we
	p98fYvXo27KK0WPOz28sHp83yQVwRDUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzHjakFXQxVax4dwCxgbGJtYuRk4OCQETiabZ89khbDGJC/fWs3UxcnEICSxilJh54gs7
	hPOLUWLX+xtMIFVsAmoSX74cBusQETCQeH36N1gRs8AyJon2I5+AHA6gDluJ42e4QWo4Bewk
	rl75wwhiCwuESVz7eZUZxGYRUJW4/2sNG4jNC1TedPgGC4QtKPFj8j0wm1lAS2L9zuNMELa8
	xOY1b5lBxksIqEs8+qsLcYKRxOlPe9khSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGK
	phYkFxQnpeca6RUn5haX5qXrJefnbmIEp49n0jsYVzVYHGIU4GBU4uF9sH1OkBBrYllxZe4h
	RgkOZiUR3vnpc4OEeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+Y2vJK4g2NTcyMLI3MLIxM
	zM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgXFlEIOk14y/nb3lT7v+ThZ78PzC44ds
	UefaKu/UX1mSmDIh2q/vRtTdprNnDCPlWV81LvC1yGI3XXJ7936rDzaSq7uEOvx+T7bPPhO/
	8XesUoZMv2GlrN2J1wo1a2dPqtmzZ/eMNSbV74xEsiVcJfYGzHt2c+6/b5+cPNfv3OZpmLfj
	tfVN3RVKLMUZiYZazEXFiQB3pzA0YwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/clocksource/sh_mtu2.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 3cf1283..d8ed6e6 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -358,7 +358,6 @@ static int sh_mtu2_probe(struct platform_device *pdev)
 	ret = sh_mtu2_setup(p, pdev);
 	if (ret) {
 		kfree(p);
-		platform_set_drvdata(pdev, NULL);
 		pm_runtime_idle(&pdev->dev);
 		return ret;
 	}
-- 
1.7.10.4


