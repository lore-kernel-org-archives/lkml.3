Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbaFYKlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:41:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35861 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaFYKlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:41:22 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-92-53aaa7500084
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        sjg@chromium.org, linux-kernel@vger.kernel.org, wsa@the-dreams.de,
        cpgs@samsung.com, broonie@kernel.org
Subject: [PATCH 1/2] i2c: exynos5: remove an unnecessary read of FIFO_STATUS
 register
Date: Wed, 25 Jun 2014 16:08:16 +0530
Message-id: <1403692697-7381-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWyRsSkRjdg+apgg6erlSymPnzCZvHykKbF
	psfXWC06/n5htLi8aw6bxYzz+5gsFm37z2zxbcs2RouVJ2YxO3B6zG64yOKxc9Zddo9NqzrZ
	PDYvqffo27KK0ePkqScsHp83yQWwR3HZpKTmZJalFunbJXBl9G9fzFJwjK3iwtf/jA2MB1m7
	GDk5JARMJDpfz2WHsMUkLtxbz9bFyMUhJLCUUeLX8/PsMEVrf2yBSixilJjYfJMFwulnkjjY
	epAFpIpNwEzi4KLVYB0iAg4S89Z+ZwcpYhbYyCixZ/kFsH3CAuESHS3XmUFsFgFViRc9a8Hi
	vAIuEr8OrgIaxAG0TkFiziQbkF4JgXnsEtMn72SDqBeQ+Db5EFSNrMSmA8wQ10lKHFxxg2UC
	o+ACRoZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGIHBffrfs4k7GO8fsD7EmAw0biKzlGhy
	PjA68kriDY3NjCxMTUyNjcwtzUgTVhLnTX+UFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	kePEtMAFT/bWSZxLXb8r9Vf6IYYeFm6defYrY2LLAyJj5Xfabj7tt1bi1NFvuobqL9ZF3zv2
	9b1jdFzVjNOdnOHR5/pNnu7e5lz52PBct4PNI33tvyGcJhfcjSKeFIUeYhM8PufHBR8HH259
	IeYfjDYX3qxWEPZhnmO1ft2tE3/Pn/4Rx1FjrcRSnJFoqMVcVJwIAAUXqUWEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jAd2A5auCDT7PlbKY+vAJm8XLQ5oW
	mx5fY7Xo+PuF0eLyrjlsFjPO72OyWLTtP7PFty3bGC1WnpjF7MDpMbvhIovHzll32T02repk
	89i8pN6jb8sqRo+Tp56weHzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDdJmSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0
	kLCGMaN/+2KWgmNsFRe+/mdsYDzI2sXIySEhYCKx9scWNghbTOLCvfVANheHkMAiRomJzTdZ
	IJx+JomDrQdZQKrYBMwkDi5azQ5iiwg4SMxb+50dpIhZYCOjxJ7lF8DGCguES3S0XGcGsVkE
	VCVe9KwFi/MKuEj8OrgKaBAH0DoFiTmTbCYwci9gZFjFKJpakFxQnJSea6hXnJhbXJqXrpec
	n7uJERw7z6R2MK5ssDjEKMDBqMTDe2H2ymAh1sSy4srcQ4wSHMxKIryOc1YFC/GmJFZWpRbl
	xxeV5qQWH2I0BVo+kVlKNDkfGNd5JfGGxibmpsamliYWJmaWSuK8B1qtA4UE0hNLUrNTUwtS
	i2D6mDg4pRoYZ8cyxvHUfH+5a8a6dUYuBx7oR+y7HLj7ncGt64+usnw5szJeMHCX4boTH+77
	z2KaVPvvr/5DHw1PY9Odj3oms/58onTxI9+UfxLZHXUNkiFKDd7P6qdl32hYwHOsvbNVa1M5
	y0f/xurGDtudrDG7knLy9eb/qLqomM+4x3j11ipmqzM7eV99U2Ipzkg01GIuKk4EALZCWNyz	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an extra read of FIFO_STATUS register in the interrrupt
service routine. Which is read again before the actual use.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/i2c/busses/i2c-exynos5.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 63d2292..0d1a7bc 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -405,7 +405,6 @@ static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
 
 	int_status = readl(i2c->regs + HSI2C_INT_STATUS);
 	writel(int_status, i2c->regs + HSI2C_INT_STATUS);
-	fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
 
 	/* handle interrupt related to the transfer status */
 	if (int_status & HSI2C_INT_I2C) {
-- 
1.7.9.5

