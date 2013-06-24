Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab3FXJ0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:26:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40177 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3FXJ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:26:32 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-59-51c810baf3c7
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>, cpgs@samsung.com,
        "'Jeongtae Park'" <jtp.park@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] s5p makefiles: don't override other selections on
 obj-[ym]
Date: Mon, 24 Jun 2013 18:26:18 +0900
Message-id: <004901ce70bc$e1d04b50$a570e1f0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkzGCMAAA5gYwAMf3LxAEyH2k0A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ93dAicCDTaoWLw8pGmxpJnb4sja
	q0wWZ5vesFtc3jWHzWLP0cPsFgs2PmJ0YPd4v+8qm0ffllWMHp83yQUwR3HZpKTmZJalFunb
	JXBlXOmbyVZwiKfi1oYOlgbGp1xdjJwcEgImEnOnz2GDsMUkLtxbD2RzcQgJLGOU2HBgHwtM
	0Z2j15khEosYJZ62fYWq+ssoMXXBUVaQKjYBXYlj67eA2SIC3hKnpvwC62AW2MwocbFlK9Ao
	DqAObonVzUEgNZwCPBLr/nQyg9jCAhESDc/WMoHYLAKqEkv+LQM7iVfATuLPtWZ2CFtQ4sfk
	e2AXMQtoSazfeZwJwpaX2LzmLTPIeAkBdYlHf3VB1ooITGGU6Np3AKpGRGLfi3eMIAkJgXvs
	EvfnPGGBWCYg8W3yIRaIZlmJTQeYIT6WlDi44gbLBEaJWUhWz0KyehaS1bOQrFjAyLKKUTS1
	ILmgOCm9yFCvODG3uDQvXS85P3cTIyROe3cw3j5gfYgxGWj9RGYp0eR8YJznlcQbGpsZWZia
	mBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRUVnIKb8+8kdU//PJ
	MtyLEt6WPrubtL/HxUFMMf3IzStHlpyetKZrN0/wxXuLRKtvrT62K3WmjIGNlImnitJvbu9Z
	SjlHUvoKq3OU7+5PFbv8JroiYvYL3m0/bh3dtJ/lrpFkvuDV2R5s/BrAMFq2v+BPf2+IObMA
	v77cZy4NudllW7yWHVFiKc5INNRiLipOBAAa1ZvI6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd1dAicCDSb9srB4eUjTYkkzt8WR
	tVeZLM42vWG3uLxrDpvFnqOH2S0WbHzE6MDu8X7fVTaPvi2rGD0+b5ILYI5qYLTJSE1MSS1S
	SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
	0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8y40jeTreAQT8WtDR0sDYxPuboYOTkkBEwk7hy9
	zgxhi0lcuLeerYuRi0NIYBGjxNO2r1DOX0aJqQuOsoJUsQnoShxbvwXMFhHwljg15RczSBGz
	wGZGiYstW1m6GDmAOrglVjcHgdRwCvBIrPvTCbZBWCBCouHZWiYQm0VAVWLJv2VsIDavgJ3E
	n2vN7BC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlBhkvIaAu8eivLshaEYEpjBJd+w5A1YhI
	7HvxjnECo9AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITgPP
	pHYwrmywOMQowMGoxMP7w/J4oBBrYllxZe4hRgkOZiUR3kNXgEK8KYmVValF+fFFpTmpxYcY
	k4E+ncgsJZqcD0xReSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXAuKRkYoxSU9bNhTe2871qnvxBaZ/a9WVXz7y22Ls/eq+5tqF6au/rq5FfGFP351x7/695
	0y2Jsl6BaN3AxNZH3N93z1J8+qTJvohVvtw7TPrW14+ivDsjV6+zO+apuNxVcX4Ew0bb1tWi
	QiwXz31UMGSulprkVKZWXnbI6c37v6cmFWtf8Hy8SYmlOCPRUIu5qDgRANpJbotHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Mauro Carvalho Chehab <mchehab@redhat.com>"

commit 5f63adbb4cb9f952a8daee97f89c8811da5fd68a upstream

The $obj-m/$obj-y vars should be adding new modules to build, not
overriding it. So, it should never use
	$obj-y := foo.o
instead, it should use:
	$obj-y += foo.o

Failing to do that is very bad, as it will suppress needed modules.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/media/platform/s5p-jpeg/Makefile |    2 +-
 drivers/media/platform/s5p-mfc/Makefile  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/Makefile
b/drivers/media/platform/s5p-jpeg/Makefile
index ddc2900..d18cb5e 100644
--- a/drivers/media/platform/s5p-jpeg/Makefile
+++ b/drivers/media/platform/s5p-jpeg/Makefile
@@ -1,2 +1,2 @@
 s5p-jpeg-objs := jpeg-core.o
-obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG) := s5p-jpeg.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG) += s5p-jpeg.o
diff --git a/drivers/media/platform/s5p-mfc/Makefile
b/drivers/media/platform/s5p-mfc/Makefile
index 379008c..15f59b3 100644
--- a/drivers/media/platform/s5p-mfc/Makefile
+++ b/drivers/media/platform/s5p-mfc/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) := s5p-mfc.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) += s5p-mfc.o
 s5p-mfc-y += s5p_mfc.o s5p_mfc_intr.o
 s5p-mfc-y += s5p_mfc_dec.o s5p_mfc_enc.o
 s5p-mfc-y += s5p_mfc_ctrl.o s5p_mfc_pm.o
-- 
1.7.9.5

