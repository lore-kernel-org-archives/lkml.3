Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaB1KCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:02:16 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64678 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaB1KCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:02:09 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-69-53105e9930b3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/3] regulator: s2mps11: Constify regulator_desc array
Date: Fri, 28 Feb 2014 11:01:49 +0100
Message-id: <1393581710-17754-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393581710-17754-1-git-send-email-k.kozlowski@samsung.com>
References: <1393581710-17754-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e/4Zd2ZcQLBBkeOilpsnLGe1WLqwyds
	Fq9fGFqcbXrDbvHtSgeTxeVdc9gsZpzfx2Sx9shddouLK74wWayf8ZrFYs70d0wO3B47Z91l
	99i0qpPNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDI29AgWHGWtuD1rPVsD43WWLkZODgkB
	E4k7u1YzQthiEhfurWfrYuTiEBJYyijx4cgsZginj0ni2uQDTCBVbALGEpuXLwGrEhHYyChx
	cP9hVhCHWWAmk8Sfmw/AqoQF3CT23fnNBmKzCKhK/H3zDyzOK+AucXXpTaDdHED7FCTmTLIB
	MTkFPCQurjEEqRACqriy9y7zBEbeBYwMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCAu7L
	DsbFx6wOMQpwMCrx8E7w5A8WYk0sK67MPcQowcGsJMKb5y4QLMSbklhZlVqUH19UmpNafIiR
	iYNTqoGxQfvZnpR5NyWWn1W6HXax7FfJv+bAmYW//l3rVmO2rtbhX3jqV4Rz+nRW1e66Akeb
	E8+eu39XCnjurfi1KPKarM3h/+UicWmhrUHybJasV9iq3x2Z7sH+rl/X1f7i4UU8bUlhmfMe
	z34zq2TbJvlwMVFmlV1lxj83Xk+fosyk5dxk1f1xmbISS3FGoqEWc1FxIgBthTpEFgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Constify the regulator_desc 'regulators' array.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s2mps11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 3647d590b962..189038aecbf5 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -343,7 +343,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 
-static struct regulator_desc regulators[] = {
+static const struct regulator_desc regulators[] = {
 	regulator_desc_ldo2(1),
 	regulator_desc_ldo1(2),
 	regulator_desc_ldo1(3),
-- 
1.7.9.5

