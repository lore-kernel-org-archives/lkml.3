Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3JNIt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:49:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36649 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab3JNIt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:49:56 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-9f-525bb033518f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Sascha Hauer'" <s.hauer@pengutronix.de>
References: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
In-reply-to: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
Subject: [PATCH 06/11] regulator: mc13783: Fix checkpatch issue
Date: Mon, 14 Oct 2013 17:49:55 +0900
Message-id: <000501cec8ba$5abfbaf0$103f30d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IuZK01KcLw1AZSDCREfGxHfkpOgAAK6pQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zY13jDdFBBpdOSVtMffiEzeLywkus
	Ft+udDBZXN41h83i7/ZNLA6sHjtn3WX32LSqk82j/6+BR9+WVYwenzfJBbBGcdmkpOZklqUW
	6dslcGVMX/+IteChRMXdU31sDYzHRLsYOTkkBEwkjrStY4KwxSQu3FvP1sXIxSEksIxR4u3U
	E0AOB1hR715RiPh0Rolnbw5DFf1ilJjadB2sm01ATeLLl8PsIA0iAqoS/1+5g9QwC0xjlFjV
	95YZpEZIwFbi7ulLYDangJ3Ewm+7WEBsYQF7iYfHd7CD2CxAvTNuHQSL8wLVH918HMoWlPgx
	+R6YzSygJbF+53EmCFteYvMakPkgh6pLPPqrC3GCkcSfRkmIChGJfS/eMYKcIyFwiV1iy/kN
	UKsEJL5NPsQC0SorsekAMyQcJCUOrrjBMoFRYhaSxbOQLJ6FZPEsJCsWMLKsYhRNLUguKE5K
	LzLWK07MLS7NS9dLzs/dxAiJ0v4djHcPWB9iTAZaP5FZSjQ5HxjleSXxhsZmRhamJqbGRuaW
	ZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgXFw4S63a1X1xNn/YDrfVLb06
	gTNZFxVk3TtnuTCE+fnGkD23U9sqjzUX7TU/vX1z4UzfRUe0/3GfazDzfPfr2u8bNq9iXHyX
	nF/HZLQ2/JKTY6jts1N/cspKNsi28AWu0AmfudBIavPDlT9duc9rPDbe6cmT97TlT9PFvKrQ
	5J3tYtw2DuX+SizFGYmGWsxFxYkAvAtpb+gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV3jDdFBBntaxS2mPnzCZnF54SVW
	i29XOpgsLu+aw2bxd/smFgdWj52z7rJ7bFrVyebR/9fAo2/LKkaPz5vkAlijGhhtMlITU1KL
	FFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CWKymUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzpq9/xFrwUKLi7qk+tgbGY6JdjBwcEgImEr17
	gUxOIFNM4sK99WxdjFwcQgLTGSWevTkM5fxilJjadJ0JpIpNQE3iy5fD7CDNIgKqEv9fuYPU
	MAtMY5RY1feWGaRGSMBW4u7pS2A2p4CdxMJvu1hAbGEBe4mHx3ewg9gsQL0zbh0Ei/MC1R/d
	fBzKFpT4MfkemM0soCWxfudxJghbXmLzGpD5IEerSzz6qwtxgpHEn0ZJiAoRiX0v3jFOYBSa
	hWTQLCSDZiEZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwSngmfQOxlUNFocY
	BTgYlXh4BZyig4RYE8uKK3MPMUpwMCuJ8ArOAwrxpiRWVqUW5ccXleakFh9iTAb6cyKzlGhy
	PjA95ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY6Xnyuyd
	nmJMC+1OW0/2DJQWqso/37nU4vX2LZ+br65241e0knBjfvLYf3e69gXZ5TWybD8tPv8TO/9M
	O6HSNd947cr5dhcsFedpbfNSFX24Iu9evucPvU/7Jgo/5PX2V1Bbz/C69HHyfRX5t7cCT87g
	n7NSVyf0jYJH9HyHS++jK1/OLVC9osRSnJFoqMVcVJwIANBD3kdFAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch warnings.

  WARNING: Avoid unnecessary line continuations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/mc13783-regulator.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index f036b26..7f4a67e 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -258,34 +258,34 @@ static struct mc13xxx_regulator mc13783_regulators[] = {
 
 	MC13783_FIXED_DEFINE(REG, VAUDIO, REGULATORMODE0, mc13783_vaudio_val),
 	MC13783_FIXED_DEFINE(REG, VIOHI, REGULATORMODE0, mc13783_viohi_val),
-	MC13783_DEFINE_REGU(VIOLO, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13783_DEFINE_REGU(VIOLO, REGULATORMODE0, REGULATORSETTING0,
 			    mc13783_violo_val),
-	MC13783_DEFINE_REGU(VDIG, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13783_DEFINE_REGU(VDIG, REGULATORMODE0, REGULATORSETTING0,
 			    mc13783_vdig_val),
-	MC13783_DEFINE_REGU(VGEN, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13783_DEFINE_REGU(VGEN, REGULATORMODE0, REGULATORSETTING0,
 			    mc13783_vgen_val),
-	MC13783_DEFINE_REGU(VRFDIG, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13783_DEFINE_REGU(VRFDIG, REGULATORMODE0, REGULATORSETTING0,
 			    mc13783_vrfdig_val),
-	MC13783_DEFINE_REGU(VRFREF, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13783_DEFINE_REGU(VRFREF, REGULATORMODE0, REGULATORSETTING0,
 			    mc13783_vrfref_val),
-	MC13783_DEFINE_REGU(VRFCP, REGULATORMODE0, REGULATORSETTING0,	\
+	MC13783_DEFINE_REGU(VRFCP, REGULATORMODE0, REGULATORSETTING0,
 			    mc13783_vrfcp_val),
-	MC13783_DEFINE_REGU(VSIM, REGULATORMODE1, REGULATORSETTING0,	\
+	MC13783_DEFINE_REGU(VSIM, REGULATORMODE1, REGULATORSETTING0,
 			    mc13783_vsim_val),
-	MC13783_DEFINE_REGU(VESIM, REGULATORMODE1, REGULATORSETTING0,	\
+	MC13783_DEFINE_REGU(VESIM, REGULATORMODE1, REGULATORSETTING0,
 			    mc13783_vesim_val),
-	MC13783_DEFINE_REGU(VCAM, REGULATORMODE1, REGULATORSETTING0,	\
+	MC13783_DEFINE_REGU(VCAM, REGULATORMODE1, REGULATORSETTING0,
 			    mc13783_vcam_val),
 	MC13783_FIXED_DEFINE(REG, VRFBG, REGULATORMODE1, mc13783_vrfbg_val),
-	MC13783_DEFINE_REGU(VVIB, REGULATORMODE1, REGULATORSETTING1,	\
+	MC13783_DEFINE_REGU(VVIB, REGULATORMODE1, REGULATORSETTING1,
 			    mc13783_vvib_val),
-	MC13783_DEFINE_REGU(VRF1, REGULATORMODE1, REGULATORSETTING1,	\
+	MC13783_DEFINE_REGU(VRF1, REGULATORMODE1, REGULATORSETTING1,
 			    mc13783_vrf_val),
-	MC13783_DEFINE_REGU(VRF2, REGULATORMODE1, REGULATORSETTING1,	\
+	MC13783_DEFINE_REGU(VRF2, REGULATORMODE1, REGULATORSETTING1,
 			    mc13783_vrf_val),
-	MC13783_DEFINE_REGU(VMMC1, REGULATORMODE1, REGULATORSETTING1,	\
+	MC13783_DEFINE_REGU(VMMC1, REGULATORMODE1, REGULATORSETTING1,
 			    mc13783_vmmc_val),
-	MC13783_DEFINE_REGU(VMMC2, REGULATORMODE1, REGULATORSETTING1,	\
+	MC13783_DEFINE_REGU(VMMC2, REGULATORMODE1, REGULATORSETTING1,
 			    mc13783_vmmc_val),
 	MC13783_GPO_DEFINE(REG, GPO1, POWERMISC, mc13783_gpo_val),
 	MC13783_GPO_DEFINE(REG, GPO2, POWERMISC, mc13783_gpo_val),
-- 
1.7.10.4


