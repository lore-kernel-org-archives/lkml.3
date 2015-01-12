Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbbALIBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:01:54 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26837 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbbALIBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:01:53 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-c1-54b37f70d126
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] regulator: Update documentation after renaming function
 argument
Date: Mon, 12 Jan 2015 09:01:39 +0100
Message-id: <1421049699-5851-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t/xK7oF9ZtDDOZN47CY+vAJm8XrF4YW
	3650MFlc3jWHzYHFY+esu+wem1Z1snn0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxuxNc9gL
	PrJVNB9Zx9LA+Iy1i5GTQ0LAROLog+3MELaYxIV769m6GLk4hASWMkp87H/ECOH0MUnMfniO
	CaSKTcBYYvPyJWwgtohAhsTmeVPBJjELGEr8fPeHHcQWFgiWOPnlE5jNIqAqsevIf7BeXgE3
	idlbVjBCbJOTOHlsMusERu4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUK8/3UH49Jj
	VocYBTgYlXh4LaU2hwixJpYVV+YeYpTgYFYS4XUtAwrxpiRWVqUW5ccXleakFh9iZOLglGpg
	bGlgb676ud7ccqHZVNHihBn/pKe1TH602Pnu7Cf2Rsbnvl9+8y84ZNffBwYq//58XVLxVKv4
	dejDDOdFbEHRBqn3zec18J/LbMu9Fr7ukXaakkdptvCTfycXrN53e9GeLaEOla8u7UnwMm+r
	+Prs0ieBLxyHfD9vntpyX3LB3ebZT7dOS67q+6nEUpyRaKjFXFScCABFqfW/3AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update documentation for regulator_register() function after renaming
its argument.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5fae8cabd254..c5201b1530ee 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3573,7 +3573,7 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
 /**
  * regulator_register - register regulator
  * @regulator_desc: regulator to register
- * @config: runtime configuration for regulator
+ * @cfg: runtime configuration for regulator
  *
  * Called by regulator drivers to register a regulator.
  * Returns a valid pointer to struct regulator_dev on success
-- 
1.9.1

