Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab3LJGIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:08:44 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60070 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3LJGId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:08:33 -0500
X-AuditID: cbfee690-b7f676d00000310d-22-52a6afdf50ca
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
 <000c01cef252$1b341040$519c30c0$%han@samsung.com>
 <20131209174439.GH29268@sirena.org.uk>
In-reply-to: <20131209174439.GH29268@sirena.org.uk>
Subject: Re: [PATCH 3/6] regulator: fixed: use devm_regulator_register()
Date: Tue, 10 Dec 2013 15:08:31 +0900
Message-id: <001101cef56e$40712e50$c1538af0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac71BljfRQ/G9fWSSxCwc/IXRRGMsQAZ2+NQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zfd3765cFGexosLCY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpsDi8fOWXfZPTat6mTz6NuyitHj8ya5AJYoLpuU1JzMstQifbsErozfNz6x
	FHSzVCy9tIm5gXE2cxcjJ4eEgInE6Y83WSFsMYkL99azdTFycQgJLGOUuPytlRGm6NnpJ8wQ
	iemMErdb50M5vxglPs85xwJSxSagJvHly2H2LkYODhEBVYn/r9xBTGaBXInubekQ5bMYJbac
	fc4GUs4pYCxx6eVcVpAaYQEPiYZGEZAwC1Dn+seNTCA2r4CtxP4TDWwQtqDEj8n3wDYxC2hJ
	rN95nAnClpfYvOYtM8gYCQF1iUd/dSEOMJKY8D0bokJEYt+Ld4wgF0gInGOX6L51hx1ilYDE
	t8mHWCBaZSU2HYAGiaTEwRU3WCYwSsxCsngWksWzkCyehWTFAkaWVYyiqQXJBcVJ6UUmesWJ
	ucWleel6yfm5mxghETlhB+O9A9aHGJOB1k9klhJNzgdGdF5JvKGxmZGFqYmpsZG5pRlpwkri
	vGqPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MJZYHW1d4SeZo+mtkO72RWTOzB92ES8+
	tx9abar/6J7gp8PRuwqVLorW1Wyc+1715OxbPBtufWZItri1/1xLgKlnik7RfvdFYd0qxlPm
	6975luZxSPmCxIp+g1O3zKzdTUp1d3K2zwjWVpv7dbJCFOM7d9e+l7bX33y58CPCp/v5q7sz
	HtyZeFmJpTgj0VCLuag4EQC5hYbn3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd3765cFGTRPM7GY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpsDi8fOWXfZPTat6mTz6NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaM3zc+sRR0s1QsvbSJuYFxNnMXIyeHhICJxLPTT6BsMYkL99az
	dTFycQgJTGeUuN06nxnC+cUo8XnOORaQKjYBNYkvXw6zdzFycIgIqEr8f+UOYjIL5Ep0b0uH
	KJ/FKLHl7HM2kHJOAWOJSy/nsoLUCAt4SDQ0ioCEWYA61z9uZAKxeQVsJfafaGCDsAUlfky+
	B7aJWUBLYv3O40wQtrzE5jVvmUHGSAioSzz6qwtxgJHEhO/ZEBUiEvtevGOcwCg0C8mgWUgG
	zUIyaBaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguP9mfQOxlUNFocYBTgYlXh4
	Jf4tDRJiTSwrrsw9xCjBwawkwutZtyxIiDclsbIqtSg/vqg0J7X4EGMy0J8TmaVEk/OBqSiv
	JN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhhVJH74vAo+njZ3
	PceL6d2Vomsity5/MeNt9BWd879+bhVb+PnU1jAflXeP7pinrjvF138tcLJF+a6552b1hkw4
	E/Hf837Xg9syz3X/bj5QNGVB0B4z4x//Mv5Y79v8Zv9auZ9mMr8zfLPdsq63ah76wehZvPve
	8c32h0vrT2/4eef1xfeKzSa1DEosxRmJhlrMRcWJAH4XxRE7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 10, 2013 2:45 AM, Mark Brown wrote:
> On Fri, Dec 06, 2013 at 04:09:29PM +0900, Jingoo Han wrote:
> > Use devm_regulator_register() to make cleanup paths simpler.
> 
> This has the same issue as the gpio regulator - it needs a more complete
> conversion to devm to be safe due to the use of other resources by the
> regulator while it's running.  The conversion looks straightfoward
> though.

OK, I see.
Please ignore this patch.
Thank you for your comment.

Best regards,
Jingoo Han

