Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3IZCM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:12:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22616 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab3IZCM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:12:26 -0400
X-AuditID: cbfee68e-b7f756d000004512-d7-5243980432c2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 16/18] regulator: tps6524x: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:12:20 +0900
Message-id: <001601ceba5d$d4d86780$7e893680$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAVpvQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zI12WGc5BBl3n9CymPnzCZnF54SVW
	iyWT57NafLvSwWRxedccNgdWj52z7rJ7bFrVyeax5M0hVo++LasYPT5vkgtgjeKySUnNySxL
	LdK3S+DKuH79AEvBMY6KpRfXsjUwfmXrYuTkkBAwkehbuYgVwhaTuHBvPVhcSGAZo8T8e1ow
	NU9/vmHqYuQCii9ilPjdO5sNwvnFKPH3+mwmkCo2ATWJL18Os3cxcnCICKhK/H/lDhJmFpjK
	KNG9thxiqK3Eqd8XwRZwCthJnL62EWyxsICPxJHTl8HiLECt29+dYAaxeYHq29cvZYWwBSV+
	TL7HAjFTS2L9zuNMELa8xOY1b5lB1koIqEs8+qsLEhYRMJKYcHI+VLmIxL4X7xghfrnFLnH9
	mi7EKgGJb5MPsUC0ykpsOsAMUSIpcXDFDZYJjBKzkCyehWTxLCSLZyHZsICRZRWjaGpBckFx
	UnqRkV5xYm5xaV66XnJ+7iZGSJT27WC8ecD6EGMy0PqJzFKiyfnAKM8riTc0NjOyMDUxNTYy
	tzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2NQTnSdx1zf6f/che8ucNRx
	/jPzx9n0iOt7H5exzFXwCVZKv5h8zmTz9DL/+nLLia9KS59ze4nmVJv3JX6fnBkjr3q2oO38
	ioD3/6c0XBFhF4/NnMatE1T16GSe3uFg3ej+83f8NaMtNUxOPFXb8fvcieMH1pmky5o4SpjP
	apfu/GyaPC+HTYmlOCPRUIu5qDgRALXSw3ToAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAV2WGc5BBg97tC2mPnzCZnF54SVW
	iyWT57NafLvSwWRxedccNgdWj52z7rJ7bFrVyeax5M0hVo++LasYPT5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLh+/QBLwTGOiqUX17I1MH5l62Lk5JAQMJF4
	+vMNE4QtJnHh3nqgOBeHkMAiRonfvbOhnF+MEn+vzwarYhNQk/jy5TB7FyMHh4iAqsT/V+4g
	YWaBqYwS3WvLQWwhAVuJU78vgi3gFLCTOH1tIyuILSzgI3Hk9GWwOAtQ6/Z3J5hBbF6g+vb1
	S1khbEGJH5PvsUDM1JJYv/M4E4QtL7F5zVtmkLUSAuoSj/7qgoRFBIwkJpycD1UuIrHvxTvG
	CYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgNPJPewbiq
	weIQowAHoxIP7wVm5yAh1sSy4srcQ4wSHMxKIrzfjIBCvCmJlVWpRfnxRaU5qcWHGJOBHp3I
	LCWanA9MUXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwLgl
	N/q8/Ef22OybcUyr3067fniDxd7Htxufvph3MmbzmyV7+98Zy4cEKcx86sw++bKyUeBpsxrR
	E6k35vw5m7Fty7ojO6ZrsXV/MeD0uFJVKr4n8AT3T4dtlyQ9GT0CgqWSvp3snLBve/79j2GP
	SjM8Vr59s3Cxt3bh+j+vrJ27M49PEq7me8atxFKckWioxVxUnAgAWcS+TkcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/tps6524x-regulator.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 8b9ee39..8fe67fb 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -584,10 +584,8 @@ static int pmic_remove(struct spi_device *spi)
 
 	if (!hw)
 		return 0;
-	for (i = 0; i < N_REGULATORS; i++) {
-		regulator_unregister(hw->rdev[i]);
+	for (i = 0; i < N_REGULATORS; i++)
 		hw->rdev[i] = NULL;
-	}
 	return 0;
 }
 
@@ -631,7 +629,8 @@ static int pmic_probe(struct spi_device *spi)
 		config.init_data = init_data;
 		config.driver_data = hw;
 
-		hw->rdev[i] = regulator_register(&hw->desc[i], &config);
+		hw->rdev[i] = devm_regulator_register(dev, &hw->desc[i],
+						      &config);
 		if (IS_ERR(hw->rdev[i])) {
 			ret = PTR_ERR(hw->rdev[i]);
 			hw->rdev[i] = NULL;
-- 
1.7.10.4


