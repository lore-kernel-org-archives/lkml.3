Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab3CKGap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:30:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36308 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3CKGan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:30:43 -0400
X-AuditID: cbfee690-b7f656d0000007e3-ad-513d7a111558
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/14] power: 88pm860x_charger: drop kfree of devm_kzalloc'd
 data
Date: Mon, 11 Mar 2013 15:30:40 +0900
Message-id: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t8zI13BKttAgwutghaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj4rT1bAXt7BUdTf3MDYyPWLsYOTkkBEwkDk/qZoewxSQu3FvP
	1sXIxSEksIxRYtfirWwwRfP+LWaHSCxilHjXepsFwpnNJPHv2TOwKjYBNYkvXw6DjRIR0JBo
	Wz2FBcRmFsiXOHzoMpgtLBAsseBiKxOIzSKgKvHk2X+wOK+ArcSvRY+hbEGJH5PvQfVqSWze
	1sQKYctLbF7zlrmLkQPoInWJR391IVbpSfxa2MIOUSIise/FO0aIo5vZJZ4/1odYJSDxbfIh
	FohWWYlNB5ghSiQlDq64wTKBUWwWksWzkCyehWTxLCQbFjCyrGIUTS1ILihOSi8y0StOzC0u
	zUvXS87P3cQIiZQJOxjvHbA+xJgMtH4is5Rocj4w0vJK4g2NzYwsTE1MjY3MLc1IE1YS51Vv
	sQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwOgkKPbhk+/8kKT4qefcek9c8jy87VFdQrbs
	iYRn7i+XOr7Rn57y67LPV9vm4mtRB2d7TfFhm81+ff68JBXTF57BK1ZUTU96EZhh9MNmrdSk
	E5andZMkK/T/sgnGH1N3vH/7uZalXvqv++GtC/ja9hyrYHj+W0R7xa0EJf2ognqP7vzW7xtn
	6iqxFGckGmoxFxUnAgC3/BxFqgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAV3BKttAg+Y7PBaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4+K09WwF7ewVHU39zA2M
	j1i7GDk5JARMJOb9W8wOYYtJXLi3nq2LkYtDSGARo8S71tssEM5sJol/z56xgVSxCahJfPly
	GKxDREBDom31FBYQm1kgX+LwoctgtrBAsMSCi61MIDaLgKrEk2f/weK8ArYSvxY9hrIFJX5M
	vgfVqyWxeVsTK4QtL7F5zVvmLkYOoIvUJR791YVYpSfxa2ELO0SJiMS+F+8YJzAKzEIyaRaS
	SbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBIfCa9g3FVg8UhRgEORiUe
	3gk6toFCrIllxZW5hxglOJiVRHhXbrIJFOJNSaysSi3Kjy8qzUktPsSYDPToRGYp0eR8YJLI
	K4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbGUNaiDyv/yXyJ
	nLQ0tDHS+qbKPDOrDXzCc8683XTnMddk7rwZcy8XbI67PGt/l8uBZasWH78Qy2NsFLz+VORm
	m6qMLTqTDuXrnfR2n7I+ZT3n3c2uO+/5RIk0toj1G/Tf7a1SyjsY8vxoW7gDY9z5w+3nHSc3
	19x/vHOi98z5f/+Gah8q5fxwSImlOCPRUIu5qDgRAFuvWS4IAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_kzalloc function allocates memory that is released
automatically, when a driver detaches. Thus, there is no reason
to explicitly call kfree in probe or remove functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/88pm860x_charger.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/power/88pm860x_charger.c b/drivers/power/88pm860x_charger.c
index 4b37a5a..36fb4b5 100644
--- a/drivers/power/88pm860x_charger.c
+++ b/drivers/power/88pm860x_charger.c
@@ -714,7 +714,6 @@ out_irq:
 	while (--i >= 0)
 		free_irq(info->irq[i], info);
 out:
-	kfree(info);
 	return ret;
 }
 
@@ -728,7 +727,6 @@ static int pm860x_charger_remove(struct platform_device *pdev)
 	free_irq(info->irq[0], info);
 	for (i = 0; i < info->irq_nums; i++)
 		free_irq(info->irq[i], info);
-	kfree(info);
 	return 0;
 }
 
-- 
1.7.2.5


