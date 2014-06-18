Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856AbaFRF1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:27:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27431 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaFRF1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:27:41 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-1a-53a123472590
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Graeme Gregory'" <gg@slimlogic.co.uk>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
Subject: [PATCH] extcon: palmas: Make of_device_id array const
Date: Wed, 18 Jun 2014 14:27:35 +0900
Message-id: <000301cf8ab6$02ebea10$08c3be30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+KtgJl4HdXR4sHRS+ZLiOBSCQ63Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zA1135YXBBi3PNC2uf3nOatG/xcXi
	8sJLrBYXnvawWVzeNYfN4nbjCjYHNo++LasYPaZO+cvocfzGdiaPz5vkAliiuGxSUnMyy1KL
	9O0SuDJu31zHXrCbrWL6Ta4Gxt2sXYycHBICJhJd7c/ZIWwxiQv31rN1MXJxCAksY5R4fXg7
	E0zR2741zBCJ6YwSxxetBusQEvjNKPHsgxaIzSagJvHly2GwuIiAlsTEzplMIA3MAkcYJXbP
	6mQESQgL2El8XDCRGcRmEVCV2Db/GtgGXgFbiS2nl0LZghI/Jt9jAbGZgQat33mcCcKWl9i8
	5i1QLwfQReoSj/7qQuzSk1j19SwjRImIxL4X7xhB9koIHGKXWDH1ChPELgGJb5MPsUD0ykps
	OsAM8ZikxMEVN1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFhnrFibnFpXnpesn5
	uZsYIXHXu4Px9gHrQ4zJQOsnMkuJJucD4zavJN7Q2MzIwtTE1NjI3NKMNGElcd6kh0lBQgLp
	iSWp2ampBalF8UWlOanFhxiZODilGhiZlslOuvtCapfj/7OCz7dt3PBrJe8Vm+MTs1Qm9E++
	0fO2dFHK89Livq8Pu87PWxwdWnbfMrTfQetgVZlQ6R+WLpsy3fDOSHVL1zSNyGk7L9+3+jsz
	8cTCfQtuNlqpnppk8maLn9Rjndo10w+/eXhn+8qnHHf3zDRhmXWilf9Cw1OTrU2WtSWTlFiK
	MxINtZiLihMB8X1H5NECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQV135YXBBvMeqFpc//Kc1aJ/i4vF
	5YWXWC0uPO1hs7i8aw6bxe3GFWwObB59W1Yxekyd8pfR4/iN7UwenzfJBbBENTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm3L65jr1gN1vF9JtcDYy7WbsYOTkkBEwk3vat
	YYawxSQu3FvP1sXIxSEkMJ1R4vii1ewgCSGB34wSzz5ogdhsAmoSX74cBouLCGhJTOycyQTS
	wCxwhFFi96xORpCEsICdxMcFE8GmsgioSmybf40JxOYVsJXYcnoplC0o8WPyPRYQmxlo0Pqd
	x5kgbHmJzWveAvVyAF2kLvHory7ELj2JVV/PMkKUiEjse/GOcQKjwCwkk2YhmTQLyaRZSFoW
	MLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO6mdSOxhXNlgcYhTgYFTi4eXIXRAsxJpY
	VlyZe4hRgoNZSYT3PdPCYCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OByacvJJ4Q2MTMyNL
	IzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgXCBr+cc6MtYwZImsRPYf70vv
	1Xbev75J9C7/94s/dVJnLip1FaxfVTA7aeGEbuPMoqe9kzf8K5HacdNRM0An5+G5omdlm+Ln
	n5F72ti2K9/L/csuTZ1Hgb0Npx1Lt3XsOxvytrJy8j/JPo0/O+3SErWfcK0PUW2P9xHv3WXe
	H/huQW6PvoiCEktxRqKhFnNRcSIALXCk0S4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle
it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/extcon/extcon-palmas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 7417ce8..5efa96c 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -278,7 +278,7 @@ static int palmas_usb_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(palmas_pm_ops, palmas_usb_suspend, palmas_usb_resume);
 
-static struct of_device_id of_palmas_match_tbl[] = {
+static const struct of_device_id of_palmas_match_tbl[] = {
 	{ .compatible = "ti,palmas-usb", },
 	{ .compatible = "ti,palmas-usb-vid", },
 	{ .compatible = "ti,twl6035-usb", },
-- 
1.7.10.4


