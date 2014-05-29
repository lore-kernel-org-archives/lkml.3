Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaE2XrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:47:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21889 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaE2XrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:47:00 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7f2f6d0000040c4-31-5387c6f1c027
Content-transfer-encoding: 8BIT
Message-id: <5387C6F1.5060702@samsung.com>
Date: Fri, 30 May 2014 08:46:57 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com
Subject: Re: [PATCH 3/4] regulator: s2mps11: Set offset to voltage hexadecimal
 code of S2MPU02 LDO regulators
References: <1401275411-21947-4-git-send-email-cw00.choi@samsung.com>
 <1401353566.25628.11.camel@AMDC1943>
In-reply-to: <1401353566.25628.11.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkRPfjsfZgg5PvlSymPnzCZtF59gmz
	xesXhhZnm96wW9z/epTR4tuVDiaLy7vmsFncblzBZnG6m9Xi4oovTA5cHjtn3WX32LSqk83j
	zrU9bB7zTgZ69G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8b1nVeZCtazVbTei29gnMLaxcjB
	ISFgInF0a1gXIyeQKSZx4d56ti5GLg4hgaWMEneW32WESJhI/Fl+nBEisYhR4saeWewgCV4B
	QYkfk++xgAxiFpCXOHIpGyTMLKAuMWneImaI+teMErsuTGGDqNeSaGpbygxiswioSvw7sZIV
	xGYDiu9/cQOsRlQgTGLl9CssILaIgKHEwd3bmUAGMQvcY5RY+XYKWLOwQL5E99EOsAYhgRyJ
	h2/PgB3ECdSw8NJ7Noir37JLLD5QBbFMQOLb5EMsEB/LSmw6wAxRIilxcMUNlgmMYrOQvDML
	4Z1ZSN5ZwMi8ilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMwJk//ezZxB+P9A9aHGJOBNk5k
	lhJNzgfGdF5JvKGxmZGFqYmpsZG5pRlpwkrivOmPkoKEBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1MEZaaEj6O5z+1GD1p2jpPc2QV8vXFCn6s/26INvt52l271bhqvdBalbKzs9Lljmo1//R
	2up0V6q9+bOEROy5OuYdc2OynF+sljmndLgjgLntY1mtqWTScsUZtgY11yKaA1jnveGf4BrG
	rH1ub1OghN+TuyLvEkLErTqPpM8rdZ4U2Th1ThSrEktxRqKhFnNRcSIAFb0JpN8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAd2Px9qDDdb2SFtMffiEzaLz7BNm
	i9cvDC3ONr1ht7j/9SijxbcrHUwWl3fNYbO43biCzeJ0N6vFxRVfmBy4PHbOusvusWlVJ5vH
	nWt72DzmnQz06NuyitHj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	NYwZ13deZSpYz1bRei++gXEKaxcjJ4eEgInEn+XHGSFsMYkL99azdTFycQgJLGKUuLFnFjtI
	gldAUOLH5HssXYwcHMwC8hJHLmWDhJkF1CUmzVvEDFH/mlFi14UpbBD1WhJNbUuZQWwWAVWJ
	fydWgi1jA4rvf3EDrEZUIExi5fQrLCC2iIChxMHd25lABjEL3GOUWPl2ClizsEC+RPfRDrAG
	IYEciYdvz4AdxAnUsPDSe7YJjAKzkNw3C+G+WUjuW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjOOqfSe1gXNlgcYhRgINRiYe3MbI9WIg1say4MvcQowQHs5IIr+NhoBBvSmJlVWpR
	fnxRaU5q8SHGZKDvJjJLiSbnAxNSXkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNT
	UwtSi2C2MHFwSjUwbm9J/aSdeGO308ygY+vixIzamT6WvnA2FTzn5lq8YwnDkkVbw3V+7zj1
	almLaFONpeT5iU75Xk6LdGZaeMmeEV7VfKZJV6hB0Gufr+KOZYX113md16Zc7A00ktnH0/fP
	TD1/u5YAbzar0NfL+6uedU3drZJgXfD8pfrCDMO9MQudeH2zcg8qsRRnJBpqMRcVJwIAx5dG
	2D4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 05/29/2014 05:52 PM, Krzysztof Kozlowski wrote:
> On śro, 2014-05-28 at 20:10 +0900, Chanwoo Choi wrote:
>> From: Jonghwa Lee <jonghwa3.lee@samsung.com>
>>
>> Different with s2mps1x series, s2mpus02's LDO has offset in voltage hexadecimal
>> code, which is used as in selector in regulator subsystem. It means the value of
>> minimum voltage is not start with 0x0, but has certain offset.
>> (as like BUCK regulator in both of s2mps1x and s2mpu02)
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> 
> Does it mean that driver from previous patch (2/4) does not work
> correctly and the git history is not bisectable? If so than this patch
> should be squashed with 2/4.

OK, I will.

Thanks,
Chanwoo Choi

