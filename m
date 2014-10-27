Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaJ0P3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:29:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52963 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaJ0P3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:29:33 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-fd-544e64da83b4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/8] regulator: max77686: Make regulator_desc array const
Date: Mon, 27 Oct 2014 16:03:42 +0100
Message-id: <1414422226-10948-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xa7q3UvxCDPofqFlsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK2PzhPlvBC9aKs3cnMzcw/mTp
	YuTkkBAwkfj4vx/KFpO4cG89WxcjF4eQwFJGiWNHljGBJIQE+pgkvuxSBLHZBIwlNi9fAlYk
	ItDJLNFzsJcZxGEWWM0k8fPKKWaQKmEBT4lXezpYQWwWAVWJtxcfMYLYvALuEg+2PGGEWCcn
	cfLYZLAaTgEPidf3vzJDbHOX+Px+K+MERt4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3
	MUJC/MsOxsXHrA4xCnAwKvHw7pjmGyLEmlhWXJl7iFGCg1lJhPdUgF+IEG9KYmVValF+fFFp
	TmrxIUYmDk6pBsYFqvoJzi73PkvtcZLXqXh9NXaX3ORFj1tiZ9UVn21Q9eKX4t1otXWuk0jU
	1Fu2ESJn+/SKEp6nPbFfdPvgmWTzl1JCbtzv3H7c69bJFE/m9K1fNrXD1GxfYfrs4LaUfTzZ
	3WHal7leltyYfT6m9MM8tlgWr8g+XRa59fsr9uybLXFz+Xq/eCWW4oxEQy3mouJEACjvuX5P	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator_register() expects array of 'regulator_desc' to be const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77686.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 04af7a2b0910..7930b4f82c0b 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -395,7 +395,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 			<< MAX77686_OPMODE_BUCK234_SHIFT,		\
 }
 
-static struct regulator_desc regulators[] = {
+static const struct regulator_desc regulators[] = {
 	regulator_desc_ldo1_low(1),
 	regulator_desc_ldo_low(2),
 	regulator_desc_ldo(3),
-- 
1.9.1

