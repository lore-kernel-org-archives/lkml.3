Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab3IBKIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:08:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19802 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab3IBKIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:08:20 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-2c-52246392e4aa
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, "'Mark Brown'" <broonie@linaro.org>
References: <1377948564-8383-1-git-send-email-broonie@kernel.org>
 <1377948564-8383-4-git-send-email-broonie@kernel.org>
In-reply-to: <1377948564-8383-4-git-send-email-broonie@kernel.org>
Subject: RE: [PATCH 04/11] regulator: s2mps11: Convert to
 devm_regulator_register()
Date: Mon, 02 Sep 2013 19:08:13 +0900
Message-id: <0bfc01cea7c4$5825e470$0871ad50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHQ0M3pMhjX+2mLni6L+4Gx2JAHTwLv1vArmZZn3KA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zfd1JySpBBg8fKVpMffiEzWLT9eus
	Ft+udDBZvD/0jNni8q45bBbL3/5nc2Dz2DnrLrvHplWdbB53ru1h87j97zGzx8uJv9k8Pm+S
	C2CL4rJJSc3JLEst0rdL4Mr4/OgWY8FOpopFh/pZGxgbmboYOTkkBEwkdk87xQhhi0lcuLee
	rYuRi0NIYBmjROOST6xdjBxgRVd/SEPEpzNKLDzxhxHC+cMoMaX1DgtIN5uAhsTK3W/ZQGwR
	AR+J69dXsIMUMQt0MUr83zmdFSQhJFApsaL1M1gRp4CTxIVJEA3CAqESy5Y9BBvEIqAq8fjy
	bLA4r4ClxOcbfSwQtqDEj8n3wGxmAS2J9TuPM0HY8hKb17xlhnhBQWLH2deMEEdYSZz53MMM
	USMise/FO7CrJQQ+sku0X7rHDrFMQOLb5EMsEG/KSmw6ADVHUuLgihssExglZiFZPQvJ6llI
	Vs9CsmIBI8sqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJAInriD8f4B60OMyUDrJzJLiSbn
	AxNAXkm8obGZkYWpiamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY
	9RepT0oq72uK2rP11s5IPVZjCWbmZyxZP/cUfm8Pnz7znPRJk8gVYSnvdJ9xWH1exeR4UODY
	+7daHRZi99U3dSxYz3Qr09nSl3fLlh9TPPcuffVS/W9nP4/97A0bGRrCdG/Fm8cHbt4a4PvI
	6NWy9R1hFfHdQdsbLm8rPyUv5vbUf3quGJOFEktxRqKhFnNRcSIAa2guq/YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jQd1JySpBBs/OyFpMffiEzWLT9eus
	Ft+udDBZvD/0jNni8q45bBbL3/5nc2Dz2DnrLrvHplWdbB53ru1h87j97zGzx8uJv9k8Pm+S
	C2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8fnRLcaCnUwViw71szYw
	NjJ1MXJwSAiYSFz9Id3FyAlkiklcuLeerYuRi0NIYDqjxMITfxghnD+MElNa77CAVLEJaEis
	3P2WDcQWEfCRuH59BTtIEbNAF6PE/53TWUESQgKVEitaP4MVcQo4SVyYBNEgLBAqsWzZQ7BB
	LAKqEo8vzwaL8wpYSny+0ccCYQtK/Jh8D8xmFtCSWL/zOBOELS+xec1bZohTFSR2nH3NCHGE
	lcSZzz3MEDUiEvtevGOcwCg0C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS
	9ZLzczcxgtPDM6kdjCsbLA4xCnAwKvHwVqxQDhJiTSwrrsw9xCjBwawkwvuIWSVIiDclsbIq
	tSg/vqg0J7X4EGMy0KcTmaVEk/OBqSuvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp
	2ampBalFMFuYODilGhg9WhWkWbec+mlmPke+/UxwgOyipyvmFWlIymzfe/7MA2EnF/dOI2v/
	JWc23NjGXhOw2ay4ielUZMVCVd23s1lm39Cf3KF1fd/k1Z3cL2JWaj6f/ctdYHLBLfsMLUtp
	3+/Nk7+/0/i/+ub1Ds2HIjl6X1vvKH+b9YA/p+ujUNhcper+0pCT/DVKLMUZiYZazEXFiQDe
	GNjHUwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 31, 2013 8:29 AM, Mark Brown wrote:

> Subject: [PATCH 04/11] regulator: s2mps11: Convert to devm_regulator_register()
> 
> From: Mark Brown <broonie@linaro.org>
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

