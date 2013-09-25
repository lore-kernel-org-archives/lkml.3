Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab3IYH6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:58:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24287 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3IYH6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:58:05 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-e1-5242978b50e4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 06/20] regulator: fixed: use devm_regulator_register()
Date: Wed, 25 Sep 2013 16:58:03 +0900
Message-id: <000f01ceb9c4$f65865c0$e3093140$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAASi8A
Content-language: ko
x-cr-hashedpuzzle: D65r FSbC FVMw KXud Kdzj M0Sr NuyH VeiF Y3u2 ZQAc b9/Z cUrK
 jCq/ kKFT rM4q
 tjVb;4;YgByAG8AbwBuAGkAZQBAAGsAZQByAG4AZQBsAC4AbwByAGcAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABnAGkAcgBkAHcAbwBvAGQAQABnAG0AYQBpAGwALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{E4AB8071-78DB-49A2-9F26-5AF76B785A19};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 25 Sep 2013 07:57:57
 GMT;WwBQAEEAVABDAEgAIAAwADYALwAyADAAXQAgAHIAZQBnAHUAbABhAHQAbwByADoAIABmAGkAeABlAGQAOgAgAHUAcwBlACAAZABlAHYAbQBfAHIAZQBnAHUAbABhAHQAbwByAF8AcgBlAGcAaQBzAHQAZQByACgAKQA=
x-cr-puzzleid: {E4AB8071-78DB-49A2-9F26-5AF76B785A19}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zfd3u6U5BBtuvWFlMffiEzeLywkus
	Ft+udDBZXN41h82BxWPnrLvsHptWdbJ59G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8b3vywF
	5zkqNi2/ydLAuJC9i5GTQ0LARKLnz2s2CFtM4sK99UA2F4eQwDJGiVmrnzHBFH06/psVIjGd
	UaJ3zlmwbiGBX4wS+x4kgthsAmoSX74cBopzcIgIqEr8f+UOYjIL5Ep0b0uHqLaVWP73NguI
	zSlgJ7Hs3mewvcICbhK7b61gBrFZgDobZ/SD1fAC1T89OoEZwhaU+DH5HlicWUBLYv3O40wQ
	trzE5jVvmUFWSQioSzz6qwsSFhEwkvhz+DgrRImIxL4X7xhBrpcQaGCV+DB1AdS/phITWm9B
	JV6yS7y+8pQF4ggBiW+TD7FADJWV2HSAGaJeUuLgihssExilZiE5aRaSk2YhOWkWkt0LGFlW
	MYqmFiQXFCelF5nqFSfmFpfmpesl5+duYoRE8MQdjPcPWB9iTAZaP5FZSjQ5H5gA8kriDY3N
	jCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAqCRr+c9i8j99
	Z41rfoe3FcY+0/retehnZfHNHSqLJi6zDXN06ivujiq6lRfHIGlcv+XX6k+Xnnjue53rYn/j
	nnm/Z0XKm9krFkS9u15jcD6e+e4ujR8HWidPnxEs3LnWZOeLC0fNoxddL7NjmzL3QNAMSZHX
	9kssAgoNopw1EvPyA3Icd+oGKrEUZyQaajEXFScCABAhoV72AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jQd3u6U5BBt0bzCymPnzCZnF54SVW
	i29XOpgsLu+aw+bA4rFz1l12j02rOtk8+rasYvT4vEkugCWqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2inkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwjjHj+1+WgvMcFZuW32RpYFzI3sXIySEhYCLx6fhvVghbTOLCvfVs
	XYxcHEIC0xkleuecBSsSEvjFKLHvQSKIzSagJvHly2GgOAeHiICqxP9X7iAms0CuRPe2dIhq
	W4nlf2+zgNicAnYSy+59ZgOxhQXcJHbfWsEMYrMAdTbO6Aer4QWqf3p0AjOELSjxY/I9sDiz
	gJbE+p3HmSBseYnNa94yg6ySEFCXePRXFyQsImAk8efwcVaIEhGJfS/eMYJcLyHQwCrxYeoC
	Noi3TCUmtN5inMAoMgvJillIVsxCsmIWklkLGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+du
	YgSnh2fSOxhXNVgcYhTgYFTi4RU46hgkxJpYVlyZe4hRgoNZSYS3aKpTkBBvSmJlVWpRfnxR
	aU5q8SHGZGAITGSWEk3OB6auvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphak
	FsFsYeLglGpgNEjvzg8oCA1NWP5e8+1m0YoFZ+9Pr9yp8cXY+7VistHR+5efe2/5Ucpv2p+1
	4nE4i88B/u1+rz8cnrFwiuPv6upEVsuOaaz9h3J1/6hH2FzJiWO9ESbY+uG+ZF5m8tHDz49s
	m1L6uEo2p+JKle+29PkWpfbrZgud7eK0DnecXcq5J8sy9UeFEktxRqKhFnNRcSIADCy7nlMD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/fixed.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index de811f3..5dadcad 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -188,7 +188,8 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	cfg.driver_data = drvdata;
 	cfg.of_node = pdev->dev.of_node;
 
-	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
+	drvdata->dev = devm_regulator_register(&pdev->dev, &drvdata->desc,
+					       &cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
@@ -214,7 +215,6 @@ static int reg_fixed_voltage_remove(struct platform_device *pdev)
 {
 	struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
 
-	regulator_unregister(drvdata->dev);
 	kfree(drvdata->desc.supply_name);
 	kfree(drvdata->desc.name);
 
-- 
1.7.10.4


