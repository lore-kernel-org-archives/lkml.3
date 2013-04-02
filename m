Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761185Ab3DBJa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:30:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43686 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760410Ab3DBJaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:30:55 -0400
X-AuditID: cbfee68e-b7f946d000001e37-da-515aa542f11f
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Russ Dill'" <Russ.Dill@ti.com>
Subject: [PATCH 3.8-stable] regulator: core: Log when a device causes a voltage
Date: Tue, 02 Apr 2013 18:30:42 +0900
Message-id: <009001ce2f84$beb22ea0$3c168be0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPog==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t8zQ12npVGBBi+b9S3+zT7FZnF51xw2
	i6btE9gtpl4/ymSxYOMjRgdWj5cTf7N5HL+xncnj8ya5AOYoLpuU1JzMstQifbsErozWqaeY
	C15wV9w994G9gfE1ZxcjJ4eEgInE1huNLBC2mMSFe+vZuhi5OIQEljFKXFz9jh2m6NHM/8wQ
	iUWMEm/6z7NDOH8ZJb7dnsgMUsUmoCtxbP0WVhBbREBBYnPvM1aQImaBCYwSH7a9BSsSFvCX
	WHByESOIzSKgKnHrSycbiM0rYCdx53QnI4QtKPFj8j2wm5gFtCTW7zzOBGHLS2xeAzKHA+gk
	dYlHf3UhdulJzHw5FapERGLfi3eMIHslBLaxS3zd9YYNYpeAxLfJh1ggemUlNh1ghvhMUuLg
	ihssExjFZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJBI69vB
	ePOA9SHGZKD1E5mlRJPzgZGaVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFq
	UXxRaU5q8SFGJg5OqQZGc59D+2oXNfvEzF7it/+rr4PPKkb/+L98OqXm2ssS9/JOTz5zpnIN
	67NZ4THy/3PZuLsq15TvOue7MUn7hVE1ww+jmoeW/9I22l/2r1m6X/2t883be8KYN7z9cddu
	SY3QQZupcvO+e7Qeyl85tTexWk3u1PUHi8qvva2rj2ZqKDnF2nLC7ss+JZbijERDLeai4kQA
	+wXaG8oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jAV2npVGBBmdva1n8m32KzeLyrjls
	Fk3bJ7BbTL1+lMliwcZHjA6sHi8n/mbzOH5jO5PH501yAcxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZrVNPMRe84K64e+4DewPja84uRk4OCQETiUcz/zND2GISF+6t
	Z+ti5OIQEljEKPGm/zw7hPOXUeLb7YlgVWwCuhLH1m9hBbFFBBQkNvc+YwUpYhaYwCjxYdtb
	sCJhAX+JBScXMYLYLAKqEre+dLKB2LwCdhJ3TncyQtiCEj8m32MBsZkFtCTW7zzOBGHLS2xe
	AzKHA+gkdYlHf3UhdulJzHw5FapERGLfi3eMExgFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJB
	cVJ6rqFecWJucWleul5yfu4mRnAcP5PawbiyweIQowAHoxIPr8OcyEAh1sSy4srcQ4wSHMxK
	IrxbdaMChXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmGLySuINjU3MjCyNzCyMTMzNSRNW
	Euc90GodKCSQnliSmp2aWpBaBLOFiYNTqoHR6NpJsd/P/oYIX3hx/qT9ytQVKgeNI7cc2zBR
	Id19jab3KbUVjxqTNs7b9+abmWPCyemLpkh/MZGoT9r49Jmtgc3BnneKrUYHp7tubjbKPuS0
	2sPTKs2JI1/sLP8E3dv6ZvMctov6iHxYw+60/e6zpLctzSkKVzfOrw7q46m2TE90PrzDg1lJ
	iaU4I9FQi7moOBEAtT+eJCcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Russ Dill <Russ.Dill@ti.com>"

commit 6e45eb12fd1c741d556bf264ee98853b5f3104e5 upstream.

commit dd8004af: 'regulator: core: Log when a device causes a voltage
constraint fail', tried to print out some information about the
check consumer min/max uV fixup, however, it uses a garbage pointer
left over from list_for_each_entry leading to boot messages in the
form:

'[    2.079890] <RANDOM ASCII>: Restricting voltage,
3735899821-4294967295uV'

Because it references regulator->dev, it could potentially read memory from
anywhere causing a panic.

This patch instead uses rdev and the updated min/max uV values.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/regulator/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2785843..5a0f54a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -200,8 +200,8 @@ static int regulator_check_consumers(struct
regulator_dev *rdev,
 	}
 
 	if (*min_uV > *max_uV) {
-		dev_err(regulator->dev, "Restricting voltage, %u-%uuV\n",
-			regulator->min_uV, regulator->max_uV);
+		rdev_err(rdev, "Restricting voltage, %u-%uuV\n",
+			*min_uV, *max_uV);
 		return -EINVAL;
 	}
 
-- 
1.7.9.5

