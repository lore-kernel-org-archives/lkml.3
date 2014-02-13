Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaBMJOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:14:52 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54737 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbaBMJOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:14:36 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-cc-52fc8cf0a12e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH v2 06/14] regulator: s2mps11: Constify regulator_desc array
Date: Thu, 13 Feb 2014 10:13:59 +0100
Message-id: <1392282847-25444-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4Zd0PPX+CDFqvKltsnLGe1WLqwyds
	Fq9fGFqcbXrDbnH/61FGi29XOpgsLu+aw2Yx4/w+Jou1R+6yW5zuZrW4uOILkwO3x85Zd9k9
	Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlXHoy2vGgslsFfunT2Fv
	YJzN2sXIySEhYCLx/8gnJghbTOLCvfVsXYxcHEICSxkl3r79BuX0MUl8m/8ErIpNwFhi8/Il
	YAkRgc2MEou/X2UFcZgFepkkVqzYCVYlLOAtcXf6ajYQm0VAVeJW13sWEJtXwF1iWecbIJsD
	aJ+CxJxJNiBhTgEPiX8/fjOD2EJAJT2LZ7FPYORdwMiwilE0tTS5oDgpPddIrzgxt7g0L10v
	OT93EyMkCL/uYFx6zOoQowAHoxIP74PFv4OEWBPLiitzDzFKcDArifDKSPwJEuJNSaysSi3K
	jy8qzUktPsTIxMEp1cDIX8CT8kt0+8Np+1ZoxIUZstn3nU840e7yWPe4zbmzD1abfPkeW9VS
	3b7S8eSlgyy/9stFKl6eof75incYq8v3R+6NN/9xTlLikVEq+Z//tul499tWrvgNHH/lLdZf
	c/95Jzsk/kRhzXPpr8cdEqUWcjxwn+Pxs5bZ78JsS6d52yssdQ8tMLdQYinOSDTUYi4qTgQA
	6o7X0CACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Constify the regulator_desc 'regulators' array.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
---
 drivers/regulator/s2mps11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 89966213315c..d44bd5b3fe8e 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -345,7 +345,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 
-static struct regulator_desc regulators[] = {
+static const struct regulator_desc regulators[] = {
 	regulator_desc_ldo2(1),
 	regulator_desc_ldo1(2),
 	regulator_desc_ldo1(3),
-- 
1.7.9.5

