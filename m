Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaBKNHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:07:55 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32478 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaBKNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:04:16 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-93-52fa1fce8153
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 06/14] regulator: s2mps11: Constify regulator_desc array
Date: Tue, 11 Feb 2014 14:03:49 +0100
Message-id: <1392123837-5517-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4Fd1z8r+CDF6d0rPYOGM9q8XUh0/Y
	LF6/MLQ42/SG3eL+16OMFt+udDBZXN41h81ixvl9TBZrj9xltzjdzWpxccUXJgduj52z7rJ7
	bFrVyeZx59oeNo95JwM9+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK+PQl9eMBZPZKvZPn8Le
	wDibtYuRk0NCwETi68z5LBC2mMSFe+vZQGwhgaWMErMfJHQxcgHZfUwSM2a/YgJJsAkYS2xe
	voQNJCEisJlRYvH3q6wgDrNAL5PEihU7waqEBTwkHnXvYASxWQRUJfbtmgdm8wq4Sew6ugbI
	5gBapyAxZ5INSJhTwF2i79N/NpCwEFDJ8v7YCYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXr
	JefnbmKEBOCXHYyLj1kdYhTgYFTi4d2g+DNIiDWxrLgy9xCjBAezkgjvF+FfQUK8KYmVValF
	+fFFpTmpxYcYmTg4pRoYe8v+d/+pk6tfcLGapyxELutUcqewQ3bvWUG5jSnpimbC775J3nil
	lHZokfn/6MePHdVWSV0O62faesHoliDrw1eV2z7mc3LUHVF3ml8o/vLho2DvA56b+vXD5uk3
	Cj93dbxwY2FEh9Gja2/vTbr0Yuf74x3sb5xXx/YtXvh9dk9kTc2eZrV/SizFGYmGWsxFxYkA
	cqJEoB4CAAA=
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

