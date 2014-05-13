Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370AbaEMLDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:03:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59978 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760373AbaEMK7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:02 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-60-5371faf4a20d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, Milo Kim <milo.kim@ti.com>
Subject: [PATCH 06/16] mfd: lp3943: Make mfd_cell array const
Date: Tue, 13 May 2014 12:58:43 +0200
Message-id: <1399978733-13662-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t/xy7pffhUGG8y6wWXx+oWhxf2vRxkt
	Lu+aw2ax/Nc6FovT3awOrB53ru1h85h3MtCjb8sqRo/jN7YzeXzeJBfAGsVlk5Kak1mWWqRv
	l8CVcfn1ZMaCLawVl7+eYm9g3MXSxcjBISFgIvH1emAXIyeQKSZx4d56ti5GLg4hgaWMEpOm
	3GKFcPqYJLbtP84KUsUmYCyxefkSNhBbRCBL4se01WCDmAV8JWYs9AcJCwvYSixbvp0JxGYR
	UJU4tfcemM0r4C7xf9IUVohlchInj00GszkFPCRe3D4LZgsB1dxYNYllAiPvAkaGVYyiqaXJ
	BcVJ6blGesWJucWleel6yfm5mxghgfN1B+PSY1aHGAU4GJV4eD2YC4KFWBPLiitzDzFKcDAr
	ifC6fyoMFuJNSaysSi3Kjy8qzUktPsTIxMEp1cBYFPJCSUrXKUNTZoO1xpY16zLsmTMndV29
	O7Vzu+DEXTc9D2y54Xh0n13lPavnt3XarAwNZFICxG4/qHsT/e6N+RHNEy/yJpv/Pjdb/I9/
	871/mWIbTrDfMJ6m9P7N6/82u1+8CUsVf/HrS31WTdD9139CH/rLqruwc5sFzd+xT6D4+JrK
	9qwyJZbijERDLeai4kQAH3p+HfoBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mfd_add_devices() expects array of struct mfd_cell to be const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Milo Kim <milo.kim@ti.com>
---
 drivers/mfd/lp3943.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/lp3943.c b/drivers/mfd/lp3943.c
index e32226836fb4..335b930112b2 100644
--- a/drivers/mfd/lp3943.c
+++ b/drivers/mfd/lp3943.c
@@ -62,7 +62,7 @@ static const struct lp3943_reg_cfg lp3943_mux_cfg[] = {
 	{ LP3943_REG_MUX3, 0xC0, 6 },
 };
 
-static struct mfd_cell lp3943_devs[] = {
+static const struct mfd_cell lp3943_devs[] = {
 	{
 		.name = "lp3943-pwm",
 		.of_compatible = "ti,lp3943-pwm",
-- 
1.9.1

