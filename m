Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaE3AZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 20:25:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30449 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaE3AZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 20:25:13 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-3c-5387cfe886ca
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, k.kozlowski@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/3] regulator: s2mps11: Add support S2MPU02 PMIC device
Date: Fri, 30 May 2014 09:25:07 +0900
Message-id: <1401409510-28238-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkRPfF+fZgg1//+SymPnzCZnH9y3NW
	i86zT5gtXr8wtDjb9Ibd4v7Xo4wW3650MFlc3jWHzeJ24wo2i9PdrBYXV3xhcuD22DnrLrvH
	plWdbB53ru1h85h3MtCjb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4MrZdOM9S0MRVMeXwS9YG
	xv3sXYycHBICJhLv1t5kg7DFJC7cWw9kc3EICSxllLhz4CEzTNHqaa/AGoQEFjFKrD2SCFHU
	xCTx8fZDFpAEm4CWxP4XN8C6RQR6GSX6Z/YzgTjMAlMYJT52NoHtEBbwkph1YDeYzSKgKtFy
	5y4TiM0r4CpxuWEjE8Q6OYkPex6xgzRLCCxil3jy+DUTRIOAxLfJh4DWcQAlZCU2HYA6T1Li
	4IobLBMYBRcwMqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECAzz0/+eTdzBeP+A9SHGZKBx
	E5mlRJPzgXGSVxJvaGxmZGFqYmpsZG5pRpqwkjhv+qOkICGB9MSS1OzU1ILUovii0pzU4kOM
	TBycUg2MrjaMF70MN8vMEJsz4y1nx8qWXpnZAjWyEgdtmH6fVJ96S1UgkfWQogFvk3Uy12+x
	GB9O24MlCz+73Zb+ee92ac4Va50CdTnOv97tl2OjrD5svKRbqtTIPc09c8b0BZ+vfnt+oOKd
	y9dae8ljJ3aUBKrrc2aGBcrP2eGS/Hrr6aJ1k6816eQpsRRnJBpqMRcVJwIAmwlaDIkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jAd0X59uDDZrusVpMffiEzeL6l+es
	Fp1nnzBbvH5haHG26Q27xf2vRxktvl3pYLK4vGsOm8XtxhVsFqe7WS0urvjC5MDtsXPWXXaP
	Tas62TzuXNvD5jHvZKBH35ZVjB6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYczYduE8S0ETV8WUwy9ZGxj3s3cxcnJICJhIrJ72CsoWk7hwbz0biC0ksIhRYu2R
	xC5GLiC7iUni4+2HLCAJNgEtif0vbrCBJEQEehkl+mf2M4E4zAJTGCU+djaBtQsLeEnMOrAb
	zGYRUJVouXOXCcTmFXCVuNywkQlinZzEhz2P2Ccwci9gZFjFKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJERxFz6R2MK5ssDjEKMDBqMTD2xjZHizEmlhWXJl7iFGCg1lJhNfxMFCINyWxsiq1
	KD++qDQntfgQYzLQ9onMUqLJ+cAIzyuJNzQ2MTOyNDI3tDAyNidNWEmc90CrdaCQQHpiSWp2
	ampBahHMFiYOTqkGRv15wdtsQh3ehMrYvqh8dkcl8PWN6/MT5WL1mB9H1sgvsf+Slbj6Y8h8
	A65T7cs3XMgs9GLXWfO3v93CWO2CCpOsdiqHgFPCJ0aLeS/vr17U3x5Rk97J1bP758q8GTJ/
	Jfd8mFS1wEn6f0ObhuJL0aOpjrtfGaTdi3+fuU0wT2jChNoM0+BgJZbijERDLeai4kQACxSH
	guYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Samsung S2MPU02 PMIC device driver in exiting S2MPS11 PMIC
driver because S2MPU02 has a little different between S2MPU02 and S2MPS1x.
The S2MPU02 PMIC has LDO[1-28] and BUCK[1-7] regulators.

Changes from v1:
- Fix typo about patch description
- Use existing suspend_state variable instead of defining new variable for S2MPU02
- Remove unnecessary parameter of s2mps11_pmic_dt_parse()
- Remove unfit comment of s2mpu02.h file
- Both patch2 and patch3 should be squashed on patch2

Chanwoo Choi (3):
  mfd: sec-core: Add support for S2MPU02 device
  regulator: s2mps11: Add support S2MPU02 regulator device
  dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   7 +-
 drivers/mfd/sec-core.c                            |  45 +++
 drivers/mfd/sec-irq.c                             |  88 ++++++
 drivers/regulator/s2mps11.c                       | 319 ++++++++++++++++++++--
 include/linux/mfd/samsung/core.h                  |   1 +
 include/linux/mfd/samsung/irq.h                   |  24 ++
 include/linux/mfd/samsung/s2mpu02.h               | 200 ++++++++++++++
 7 files changed, 662 insertions(+), 22 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mpu02.h

-- 
1.8.0

