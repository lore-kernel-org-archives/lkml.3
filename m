Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab3GaD3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 23:29:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9702 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3GaD3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 23:29:22 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-cb-51f8848f7170
Message-id: <51F88497.5020909@samsung.com>
Date: Wed, 31 Jul 2013 12:29:27 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, "'Mark Brown'" <broonie@linaro.org>
Subject: Re: [PATCH 4/5] mmc: dw_mmc: Indicate that regulators may be absent
References: <1375184777-25404-1-git-send-email-broonie@kernel.org>
 <1375184777-25404-4-git-send-email-broonie@kernel.org>
 <003901ce8d29$610ab3f0$23201bd0$%jun@samsung.com>
In-reply-to: <003901ce8d29$610ab3f0$23201bd0$%jun@samsung.com>
Content-type: text/plain; charset=EUC-KR
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsWyRsSkRHdCy49Ag5/bWC2mPnzCZrHp+nVW
	i+2vN7JZ3PjVxmrx7UoHk8X7Q8+YLTY9vsZqcXnXHDaLI//7GS0+3L/I7MDlsXPWXXaPTas6
	2TwOXVnL6HHn2h42j81L6j1u/3vM7NG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZL5ecZSlY
	xVpxeeJjtgbGNSxdjJwcEgImEptuXWODsMUkLtxbD2RzcQgJLGWUmNWxiwmm6Mf+PlaIxCJG
	iXW/LkJVvWaUmNfyBqydV0BL4uPuQ6wgNouAqsSXTYfAVrAJ6Ehs/3YcbJKoQJjEkm+PoeoF
	JX5MvgdUw8EhIqAh8WV+AshMZoH9TBJTdn4DmyMs4CPxZ10LE8Sy9YwSTc8WMIM0cArYSXQ+
	MgOpYQbqnfr6NCOELS+xec1bZoir/7JL3LwXDHGPgMS3yYfAdkkIyEpsOgBVIilxcMUNlgmM
	YrOQXDQLydRZSKYuYGRexSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iREYsaf/PevdwXj7gPUh
	xmSglROZpUST84ERn1cSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlO
	avEhRiYOTqkGxq3v+/fe9+W+znruUXHiPBmH2vOXJy7aYmzfmfdwwqMnP14vmLBXLypx8Yre
	iPmThP4/OS5/YR+33HuVV5bPla2+GZ74r/Vrr+/bKDNBoaun3O/8COBSvBhiGlXZ2/rQ3+zf
	0fSvE/3fNSbLLr9xMy40ty4vbbtBYviUY2FtGp13+L5bNEQp2ymxFGckGmoxFxUnAgC4FK3W
	7gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jAd3+lh+BBsdXWFlMffiEzWLT9eus
	Fttfb2SzuPGrjdXi25UOJov3h54xW2x6fI3V4vKuOWwWR/73M1p8uH+R2YHLY+esu+wem1Z1
	snkcurKW0ePOtT1sHpuX1Hvc/veY2aNvyypGj8+b5AI4ohoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAjlRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYwZrxccpalYBVrxeWJj9kaGNewdDFyckgImEj82N/HCmGLSVy4t56t
	i5GLQ0hgEaPEul8XoZzXjBLzWt6wgVTxCmhJfNx9CKyDRUBV4sumQ2CT2AR0JLZ/O84EYosK
	hEks+fYYql5Q4sfke0A1HBwiAhoSX+YngMxkFtjPJDFl5zewOcICPhJ/1rUwQSxbzyjR9GwB
	M0gDp4CdROcjM5AaZqDeqa9PM0LY8hKb17xlnsAoMAvJillIymYhKVvAyLyKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIzghPJPewbiqweIQowAHoxIP74xL3wOFWBPLiitzDzFKcDArifDK
	B/0IFOJNSaysSi3Kjy8qzUktPsSYDAyBicxSosn5wGSVVxJvaGxiZmRpZG5oYWRsTpqwkjjv
	wVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MATq7VhhN4BcoipAMzWZ4rV/sZ/LiReDV3id1t67f
	NH/yzUlz/RyfYvu9ltGnWL1qlGakHRdcsH7Vme8KjKdX17SvUss5Gc5Qu45vTe7abSbNDC/q
	36dnfN+3Z70zRxObu+XGZ5IOumIlVnEdBwQev/958ce2hx2uJ1+whMw75BUsHtC1T/i4Ektx
	RqKhFnNRcSIAL5Dg7EwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

Best Regards,
Jaehoon Chung

On 07/30/2013 10:33 PM, Seungwon Jeon wrote:
> On Tue, July 30, 2013, Mark Brown wrote:
>> From: Mark Brown <broonie@linaro.org>
>>
>> Use regulator_get_optional() to tell the core that requests for regulators
>> can fail in a real system.
>>
>> Signed-off-by: Mark Brown <broonie@linaro.org>
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
> 
> Thanks,
> Seungwon Jeon
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

